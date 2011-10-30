worker_processes 12

listen "/home/ai/plague/shared/unicorn.sock", backlog: 64

preload_app true

timeout 30

stderr_path "/home/ai/plague/shared/log/unicorn.stderr.log"
stdout_path "/home/ai/plague/shared/log/unicorn.stdout.log"

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
