class SearchQueryParserBenchmarker
  require_relative 'search_query_parser'
  require 'benchmark'

  # I used these methods in pry to test different options.
  # They aren't intended to be super precise, just a rough idea of how changes
  # affect efficiency varying by duration + length for a consistent setup.

  # Results (by # of iterations):
  #   Rehearsal ---------------------------------------
  #   100   0.380000   0.000000   0.380000 (  0.387532)
  #   ------------------------------ total: 0.380000sec
  #
  #               user     system      total        real
  #   100   0.410000   0.010000   0.420000 (  0.413978)

  # running a medium benchmark:
  #   Rehearsal ----------------------------------------
  #   1000   3.420000   0.070000   3.490000 (  3.531880)
  #   ------------------------------- total: 3.490000sec
  #
  #               user     system      total        real
  #   1000   2.960000   0.070000   3.030000 (  3.050216)

  # running a long benchmark:
  #   Rehearsal -----------------------------------------
  #   10000  31.230000   0.710000  31.940000 ( 33.071085)
  #   ------------------------------- total: 31.940000sec
  #
  #                user     system      total        real
  #   10000  30.850000   0.710000  31.560000 ( 32.142797)

  #  - Per-iteration averages: (real exec time per iteration)
  #     - short:  0.004139s
  #     - med: 0.003029s
  #     - long: 0.003156s
  #     - v. long: 0.003781

  # Results (by query length):
  #   Rehearsal ---------------------------------------
  #   100   0.050000   0.000000   0.050000 (  0.052076)
  #   ------------------------------ total: 0.050000sec
  #
  #              user     system      total        real
  #   100   0.020000   0.000000   0.020000 (  0.020704)
  #
  #
  # running a short benchmark:
  #   Rehearsal ---------------------------------------
  #   100   0.290000   0.010000   0.300000 (  0.307493)
  #   ------------------------------ total: 0.300000sec
  #
  #              user     system      total        real
  #   100   0.300000   0.010000   0.310000 (  0.308432)
  #
  # running a short benchmark:
  #   Rehearsal ---------------------------------------
  #   100   3.360000   0.280000   3.640000 (  3.782188)
  #   ------------------------------ total: 3.640000sec
  #
  #              user     system      total        real
  #   100   3.680000   0.260000   3.940000 (  4.189628)
  #
  #
  # running a short benchmark:
  #   Rehearsal ---------------------------------------
  #   100 89.710000  50.010000 139.720000 ( 143.902440)
  #   ---------------------------- total: 139.720000sec
  #
  #              user     system      total        real
  #   100  90.950000  50.350000 141.300000 (144.705030)

  #   - String length averages (all short, 100 iterations): (exec time, 100 iterations)
  #     - very short ( 285 characters in string): 0.020704s
  #     - short (2850 characters in string): 0.314674s
  #     - medium (28500 in string): 4.374550s
  #     - long (2850000 in string): 144.705030s

  def self.run_varied_duration
    return [  bench_short(setup_output(50), proc{|str| @parser = new(str);}),
              bench_medium(setup_output(50), proc{|str| @parser = new(str);}),
              bench_long(setup_output(50), proc{|str| @parser = new(str);}),
              bench_extra_long(setup_output(50), proc{|str| @parser = new(str);}) ]
  end

  def self.run_varied_length
    return [  bench_short(setup_output(5), proc{|str| @parser = new(str);}),
              bench_short(setup_output(50), proc{|str| @parser = new(str);}),
              bench_short(setup_output(500), proc{|str| @parser = new(str);}),
              bench_short(setup_output(5000), proc{|str| @parser = new(str);}) ]
  end

  def initialize(string)
    return SearchQueryParser.new(string)
  end

  def self.setup_output(n)
   return "tag:'monkey' tag:'banana fun-time' monkey banana fun-time" * n
  end

  # Everything from here down is generic for my system.
  def benchmark_n_times(n, args, arg_proc, label)
    return "Arg Proc isn't a proc, this'll break" unless arg_proc.is_a?(Proc)
    return "N needs to be an integer." unless n.is_a?(Integer)
    Benchmark.bmbm do |x|
      x.report(label) { n.times { arg_proc.call(args) } }
    end
  end

  def bench_short(args, arg_proc)
    print "\n\nrunning a short benchmark:\n"
    benchmark_n_times(100, args, arg_proc, "100")
  end

  def bench_medium(args, arg_proc)
    print "\n\nrunning a medium benchmark:\n"
    benchmark_n_times(1000, args, arg_proc, "1000")
  end

  def bench_long(args, arg_proc)
    print "\n\nrunning a long benchmark:\n"
    benchmark_n_times(10000, args, arg_proc, "10000")
  end

  def bench_extra_long(args, arg_proc)
    print "\n\nrunning a veeeery long benchmark:\n"
    benchmark_n_times(100000, args, arg_proc, "100000")
  end
end
