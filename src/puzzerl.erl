-module(puzzerl).
-compile([{nowarn_unused_function, [{run_handler, 1}, {run_day, 2}]}]).
-include_lib("eunit/include/eunit.hrl").
-export([main/2]).

main(Days, Args) ->
    Pid = start(Days),
    argparse:run(Args, cli(Pid), #{progname => nil}).

start(Days) ->
    spawn(puzzerl, run_handler, [Days]).

run_day(Day, Days) ->
    io:format("== DAY ~s ==~n", [Day]),
    {ok, Input} = file:read_file("in/" ++ Day),
    Out = apply(maps:get(Day, Days), [Input]),
    io:format("~s~n", [Out]),
    Out.

run_handler(Days) ->
    receive
        days -> maps:keys(Days);
        {run,Day} -> run_day(Day, Days);
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
