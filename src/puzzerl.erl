-module(puzzerl).
-include_lib("eunit/include/eunit.hrl").
-export([main/2]).

main(Days, Args) ->
    argparse:run(Args, cli(Days), #{progname => nil}).

run_day(Day, Days) ->
    io:format("== DAY ~s ==~n", [Day]),
    {ok, Input} = file:read_file("in/" ++ Day),
    Out = apply(maps:get(Day, Days), [Input]),
    io:format("~s~n", [Out]),
    Out.

cli(Days) ->
    #{
        arguments => [
            #{name => day}
        ],
        handler => fun (#{day := Day}) -> run_cli(Days, Day) end
    }.

run_cli(Days, "all") ->
    lists:foreach(fun (Day) -> run_day(Day, Days) end, maps:keys(Days));

run_cli(Days, Day) ->
    run_day(Day, Days).
