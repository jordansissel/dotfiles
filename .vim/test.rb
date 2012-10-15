#!/usr/bin/env ruby

require "clamp"
require "cabin"

def with(value, &block) 
  block.call(value)
end # def with

class DevTool < Clamp::Command
  option ["--chdir", "-C"], "CHDIR", "Path to chdir too"
  option ["--root", "-R"], :flag, "chdir to project root"

  parameter "FILES ...", "Files to run against", :attribute_name => :files

  def logger
    return Cabin::Channel.get
  end # def logger

  def execute
    logger.level = :info
    logger.subscribe(STDOUT)
    if root?
      gitroot = `git rev-parse --show-toplevel`.split("\n").first
      @chdir = gitroot if !gitroot.nil?
    elsif chdir.nil?
      @chdir = Dir.pwd
    end

    # Append trailing / if necessary
    @chdir = "#{@chdir}/" if @chdir !~ /\/$/

    # Get paths relative to the chdir value.
    relative_paths = files.collect { |a| File.realpath(a).gsub(chdir, "") }
    if chdir
      logger.info("Changing directory", :path => Dir.pwd)
      Dir.chdir(chdir)
    end

    tests = relative_paths.collect { |p| tests_for_path(p) }.select { |p| !p.nil? }

    success = true
    tests.each do |runner, path|
      case runner
        when :rspec ; system("rspec", path)
        when :ruby ; system("ruby", path)
        when :syntax ; system("ruby", "-c", path)
      end
      success ||= $?.success?
    end # tests.each
  end # def execute

  def tests_for_path(path)
    if path =~ /^lib\//
      # Try {spec,test}/path/to/thing.rb for lib/project/path/to/thing.rb
      with(path.gsub(/^lib\/[^\/]+\//, "spec/")) { |p| path = p if File.exists?(p) }
      with(path.gsub(/^lib\/[^\/]+\//, "test/")) { |p| path = p if File.exists?(p) }

      # Try {spec,test}/path/to/thing.rb for lib/path/to/thing.rb
      with(path.gsub(/^lib\//, "spec/")) { |p| path = p if File.exists?(p) }
      with(path.gsub(/^lib\//, "test/")) { |p| path = p if File.exists?(p) }
    end

    case path
      when /^spec\// ; return [:rspec, path]
      when /^test\// ; return [:ruby, path]
      else ; return [:syntax, path]
    end
  end # def tests_for_path
end # class DevTool

DevTool.run