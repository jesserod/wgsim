#!/usr/bin/env ruby

def usage
  puts(<<-EOS
usage: #{File.basename($0)} [-s seed_multiplier] <ref> <out_prefix> <total_pairs> <num_chunks> [WGSIM_OPTS]

  -s  Will set read seed (-G) to iteration * seed_multiplier. 
      If -s is not set, no seed will be automatically sent to wgsim (but you can set manually in opts)

  Note: WGSIM_OPTS should not contain... 
    -N
    -G (only if -s is set)
EOS
)
  exit
end

seed_multiplier = 0

if ARGV.first == '-s'
  ARGV.shift
  seed_multiplier = ARGV.shift.to_i
end

if ARGV.size < 4 
  usage
end

ref = ARGV.shift
prefix = ARGV.shift
total_pairs = ARGV.shift.to_i
num_chunks = ARGV.shift.to_i

wgsim_opts = ARGV.join(" ")

pairs_per_chunk = total_pairs / num_chunks

for i in 1..num_chunks
  print "wgsim #{wgsim_opts} -N #{pairs_per_chunk}"
  print " -G #{seed_multiplier * i}" if seed_multiplier > 0
  puts " #{ref} #{prefix}1.fa.#{i} #{prefix}2.fa.#{i}"
end
