%%%-------------------------------------------------------------------
%% @doc cli top level supervisor. simple_one_for_one for dynamic open / close
%% @end
%%%-------------------------------------------------------------------

-module(cli_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_child/1, stop_child/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_child(Path) ->
    supervisor:start_child(?MODULE, [Path]).

stop_child(Pid) when is_pid(Pid) ->
    supervisor:delete_child(?MODULE, Pid).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    SupFlags = #{strategy  => simple_one_for_one,
                 intensity =>    5,
                 period    => 10
                },
    Child = #{id => ?MODULE,
              start => {cli_unixdom_listen, start_link, []},
              restart => permanent},
    {ok, {SupFlags, [Child]} }.

%%====================================================================
%% Internal functions
%%====================================================================
