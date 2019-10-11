%%%-------------------------------------------------------------------
%%% @author Sean Hinde <sean@Seans-MacBook.local>
%%% @copyright (C) 2019, Sean Hinde
%%% @doc Useful common routines
%%%
%%% @end
%%% Created : 17 Sep 2019 by Sean Hinde <sean@Seans-MacBook.local>
%%%-------------------------------------------------------------------
-module(cli_util).

-include("cli.hrl").

-export([get_name/2, get_description/2,
         get_children/3, get_children/4, get_action/2,
         get_node_type/2,
         get_list_key_names/2, get_list_key_values/2,
         set_list_key_values/3
        ]).

-export([eval_childspec/1, eval_childspec/2]).

-export([strip_ws/1]).

%% @doc Utility functions for getting the actual value of a node in a
%% tree item given the getter function and the item itself.
%% @end
get_name(#accessors{name_fun = Fn}, Item) -> Fn(Item).

get_description(#accessors{desc_fun = Fn}, Item) -> Fn(Item).

get_children(#accessors{children_fun = Fn}, Item, Txn) ->
    %% io:format("cli_util children ~p~n", [erlang:fun_info(Fn)]),
    case erlang:fun_info(Fn, arity) of
        {arity, 1} -> Fn(Item);
        {arity, 2} -> Fn(Item, Txn);
        {arity, 3} -> Fn(Item, Txn, false)
    end.

get_children(#accessors{children_fun = Fn}, Item, Txn, AddListItems) ->
    %% io:format("cli_util children ~p~n", [erlang:fun_info(Fn)]),
    case erlang:fun_info(Fn, arity) of
        {arity, 1} -> Fn(Item);
        {arity, 2} -> Fn(Item, Txn);
        {arity, 3} -> Fn(Item, Txn, AddListItems)
    end.


get_node_type(#accessors{node_type_fun = Fn}, Item) -> Fn(Item).

get_list_key_names(#accessors{list_key_names_fun = Fn}, Item) -> Fn(Item).

get_list_key_values(#accessors{list_key_values_fun = Fn}, Item) -> Fn(Item).

set_list_key_values(#accessors{set_list_key_values_fun = Fn}, Item, Value) ->
    Fn(Item, Value).

get_action(#accessors{action_fun = Fn}, Item) -> Fn(Item).

%% Get the actual children from a tree item

eval_childspec(S) ->
    eval_childspec(S, undefined).

eval_childspec(#cli_sequence{seq = [Seq|_]}, Txn) ->
    eval_childspec(Seq, Txn);
eval_childspec(#cli_tree{tree_fun = Fun, accessors = Accessors,
                         add_list_items = ALI}, Txn) ->
    {Fun(Txn), Accessors, ALI};
eval_childspec(F, Arg) when is_function(F) ->
    case erlang:fun_info(F, arity) of
        {arity, 0} -> F();
        {arity, 1} -> F(Arg)
    end;
eval_childspec(L, _Arg) when is_list(L) -> L;
eval_childspec(_, _) -> [].

%% @doc strip spaces and tabs from the start of a listy string.
-spec strip_ws(string()) -> string().
strip_ws([$\s | Str]) ->
    strip_ws(Str);
strip_ws([$\t | Str]) ->
    strip_ws(Str);
strip_ws([]) ->
    "";
strip_ws(Str) ->
    Str.


