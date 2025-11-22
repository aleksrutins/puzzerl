-module(puzzerl).
-compile([{nowarn_unused_function, [{run_handler, 1}]}]).
-include_lib("eunit/include/eunit.hrl").
-export([main/2]).

main(Days, Args) ->
    Pid = start(Days),
    argparse:run(Args, cli(Pid), #{progname => nil}).

start(Days) ->
    spawn(puzzerl, run_handler, Days).

run_handler(Days) ->
    receive
        days -> maps:keys(Days);
        {run,Day} -> apply(maps:get(Day, Days), []);
        _ -> ok
    end.

cli(Pid) ->
    #{
        arguments => [
            #{name => day}
        ],
        handler => fun (#{day := Day}) -> run_cli(Pid, Day) end
    }.

run_cli(Pid, "all") ->
    Days = Pid ! days,
    lists:foreach(fun (Day) -> Pid ! {run, Day} end, Days);

run_cli(Pid, Day) ->
    Pid ! {run, Day}.
