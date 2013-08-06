#!/usr/bin/env ruby

windows = `xdotool search --class --onlyvisible terminator`.split("\n").sort

locations = [
  { :X => 0, :Y => 0 },
  { :X => 0, :Y => 725 },
  { :X => 856, :Y => 725 },
  { :X => 1718, :Y => 725 }
]
windows.each_with_index do |w, i|
  l = locations[i]
  system("xdotool windowsize --usehints #{w} 84 32 windowmove #{w} #{l[:X]} #{l[:Y]}")
end
