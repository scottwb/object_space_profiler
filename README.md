This is just a quick hack. YMMV.

= ActiveRecordMemoryProfiler

Drop `active_record_memory_profiler.rb` in somewhere it will be loaded in your Rails app, and then call `ActiveRecordMemoryProfiler.start`. It will log all outstanding ActiveRecord::Base-derived objects to `log/ar_mem_profiler.log` every 10 seconds. See source for config options.

= ObjectMemoryProfiler

Drop `object_memory_profiler.rb` in somewhere it will be loaded by your app, and then call `ObjectMemoryProfiler.start`. It will log all outstanding ObjectSpace objects (not including strings by default) to `log/obj_mem_profiler.log` every 10 seconds. See source for config options.
