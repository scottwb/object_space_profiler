# This class is based on the MemoryProfiler script found at:
#
#  http://scottstuff.net/blog/2006/08/17/memory-leak-profiling-with-rails
#
# It is modified to not do String checking or deltas, and "top 20" summaries.
# It simply reports all outstanding ActiveRecord::Base-derived objects.
#
# Call ActiveRecordMemoryProfiler.start to start it. It will write to the
# log file log/ar_mem_profiler.log file periodically (default 10 sec).
#
class ActiveRecordMemoryProfiler
  DEFAULTS = {:delay => 10}

  # Starts the ActiveRecordMemoryProfiler.
  #
  # ====Keyed Parameters
  #
  # This method takes the following optional keyed parameters:
  #
  # <tt>:delay</tt>::
  #   The interval, in seconds, at which to dump all the outstanding
  #   ActiveRecord objects to the log file. Defaults to 10.
  #
  # ====Returns
  #
  # None.
  #
  def self.start(opt={})
    opt = DEFAULTS.dup.merge(opt)

    classes = Hash.new(0)

    Thread.new do
      file = File.open('log/ar_mem_profiler.log','w')

      loop do
        begin
          GC.start
          ObjectSpace.each_object do |o|
            if o.kind_of?(ActiveRecord::Base)
              classes[o.class.name] += 1
            end
          end

          file.puts "\n[#{Time.now.to_s(:db)}] Outstanding ActiveRecord Objects:"
          classes.each_pair do |k,v|
            file.printf "    %s (%d)\n", k, v
          end
          file.flush

          classes.clear
          GC.start
        rescue Exception => err
          STDERR.puts "** ActiveRecordMemoryProfiler error: #{err}"
        end
        sleep opt[:delay]
      end
    end
  end
end
