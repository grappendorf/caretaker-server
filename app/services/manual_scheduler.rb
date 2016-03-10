require 'rufus/scheduler'

class ManualScheduler < Rufus::Scheduler::SchedulerCore
  class ManualJobQueue < Rufus::Scheduler::JobQueue
    def next_job
      @jobs.first
    end

    def each_job
      @jobs.each { |job| yield job }
    end
  end

  class ManualCronJobQueue < Rufus::Scheduler::CronJobQueue
    def trigger_matching_jobs
    end
  end

  class ManualInJob < Rufus::Scheduler::InJob
    def determine_at
      iin = @t.is_a?(Fixnum) || @t.is_a?(Float) ? @t : Rufus.parse_duration_string(@t)
      @at = @scheduler.time_now + iin
    end
  end

  attr_reader :time_now

  def initialize opts = {}
    super
    @time_now = 0
    @logger = Grape::API.logger
  end

  def get_queue type, _opts
    if type == :cron
      ManualCronJobQueue.new
    else
      ManualJobQueue.new
    end
  end

  def in t, s = nil, opts = {}, &block
    @logger.debug "At #{@time_now} adding new job to execute in #{t}"
    add_job ManualInJob.new self, t, combine_opts(s, opts), &block
  end

  def trigger_job _params, &block
    block.call
  end

  def step interval = nil
    @logger.debug "At #{@time_now} stepping #{interval}"
    if interval
      trigger_all_jobs_in interval
    else
      trigger_next_job
    end
  end

  alias :travel :step

  def trigger_all_jobs_in interval
    now = @time_now
    @jobs.each_job do |job|
      if job.at <= now + interval
        @time_now = job.at
        @logger.debug "At #{@time_now} triggering job #{job.job_id}"
        job.trigger
        unschedule job
      end
    end
    @time_now = now + interval
  end

  def trigger_next_job
    job = @jobs.next_job
    if job
      @time_now = job.at
      @logger.debug "At #{@time_now} triggering job #{job.job_id}"
      job.trigger
      unschedule job
    end
  end

  def reset
    @time_now = 0
    @jobs = ManualJobQueue.new
  end
end
