class Refresh
  include_package 'java.util.concurrent'

  # optional, only needed if you pass config options to the job
  def initialize(options = {})

    @options = options
  end

  def run()
    executor = Executors.new_fixed_thread_pool(4)

    #puts "on demarre"
    Tribune.all.each do |t|
      executor.execute do

        #puts "On a une tribune"
        # perform work here
        now = Time.now
        to_be = (now - t.last_updated) > t.refresh_interval
        #puts "=> #{to_be}"
        if to_be
          #      tribune.with_lock do
          t.refresh
          #      end
          #      tribune.logger.info "Reload fini pour board #{tribune.name}"
        else
          #      tribune.logger.info "Pas de reload pour board #{tribune.name}"
        end
        puts "refresh pour #{t.name} fini"
      end
    end
    executor.shutdown
  end

  def on_error(exception)
    # Optionally implement this method to interrogate any exceptions
    # raised inside the job's run method.
  end
end
