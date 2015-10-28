require 'active_support/core_ext/hash/slice.rb'
require 'memory_profiler'
require 'benchmark/ips'

large_hash = (1..1_000_000).map {|i| [i, i] }.to_h
small_hash = (1..10).map {|i| [i, i] }.to_h

if ARGV.first == 'profiling'
  puts '==================================='
  puts 'Memory profiling: slice!'
  puts '==================================='
  MemoryProfiler.report(allow_files: 'activesupport/lib/active_support/core_ext/hash/slice.rb') {
    large_hash.dup.slice!(1, 2, 3)
  }.pretty_print

  puts
  puts
  puts

  puts '==================================='
  puts 'Memory profiling: slice_old!'
  puts '==================================='
  MemoryProfiler.report(allow_files: 'activesupport/lib/active_support/core_ext/hash/slice.rb') {
    large_hash.dup.slice_old!(1, 2, 3)
  }.pretty_print
else
  puts 'for large hash'
  Benchmark.ips do|x|
    x.report('slice!'){ large_hash.dup.slice!(1, 2, 3) }
    x.report('slice_old!'){ large_hash.dup.slice_old!(1, 2, 3) }
  end

  puts 'for small hash'
  Benchmark.ips do|x|
    x.report('slice!'){ small_hash.dup.slice!(1, 2, 3) }
    x.report('slice_old!'){ small_hash.dup.slice_old!(1, 2, 3) }
  end
end
