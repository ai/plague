shared_dir = '/home/ai/plague/shared'

pid    "#{shared_dir}/pids/unicorn.pid"
listen "#{shared_dir}/unicorn.sock", backlog: 64

worker_processes 4
preload_app true
timeout 180

stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid)
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH; end
  end
end
