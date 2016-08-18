-module(server).

% exposed API
-export([start_link/1]).

% internal
-export([init/1, init/2, handle/0]).

start_link(Port) ->
	spawn_link(?MODULE, init, [Port]).

init(Port) ->
	{ok, Listen} = gen_tcp:listen(Port, [binary, {active, true}]),
	init(Port, Listen).

init(Port, Listen) ->
	{ok, Accept} = gen_tcp:accept(Listen),
	Pid = spawn(?MODULE, handle, []),
	gen_tcp:controlling_process(Accept, Pid), 
	init(Port, Listen).

handle() ->
	receive
		{tcp, _Port, <<"auth:",Id/binary>>} -> 
			io:format("client ~s requesting session ~n", [Id]),
			% TODO check for client Id and establish a session
			handle();
		% TODO fill in protocol
		{tcp, Port, Packet} -> 
			io:format("~w received ~s ~n", [Port, Packet]),
			handle();
        stop -> 
          ok;
		_ -> 
			handle()
	end.
