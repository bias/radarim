-module(client).

% exposed API
-export([start_link/1]).

% internal
-export([init/1]).

start_link([Port]) ->
	spawn_link(?MODULE, init, [[Port]]).

init([Port]) ->
	{ok, Connect} = gen_tcp:connect({127,0,0,1}, Port, [binary, {active, true}]),
    init([Port, Connect]);

init([_Port, Connect]) ->
    gen_tcp:send(Connect, <<"auth:tom">>),
	handle().

handle() ->
	receive
        stop -> 
          ok;
		_ -> 
			handle()
	end.
