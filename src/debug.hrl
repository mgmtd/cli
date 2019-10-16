-define(DEBUG, 1).

-ifdef(DEBUG).
-define(DBG(DATA), io:format("~p:~p: ~p~n",[?MODULE, ?LINE, DATA])).
-define(DBG(FORMAT, ARGS), io:format("~p:~p: " ++ FORMAT,[?MODULE, ?LINE] ++ ARGS)).
-else.
-define(DBG(DATA), ok).
-define(DBG(FORMAT, ARGS), ok).
-endif.
