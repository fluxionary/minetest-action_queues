# action_queues

minetest mod which provides an API for queuing things for batch processing w/ various ways to specify the batch "size".

## api

* `action_queues.api.create_serverstep_queue(params)`
  returns a queue, to which jobs can be added which will execute on some future server step.
  `params` can be one of
  * `{us_per_step = n}`
    execute queued entries until n us (microseconds) have elapsed.
  * `{every_n_steps = n, num_per_step = m}`
    execute at most m queued entries every n server steps.
  * `{every_n_seconds = n, num_per_step = m}`
    execute at most m queued entries after at least n seconds have elapsed.
  * `{num_per_step = m}`
    execute at most m queued entries on each server step.

to add entires to the queue, do

```
queue:push_back(function(params, dtime, n)
    ...
end)
```

if the function returns "true", queue processing will be stopped until the next cycle.
