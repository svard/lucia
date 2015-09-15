defmodule Lucia.ControllerTest do
  use ExUnit.Case
  alias Lucia.State
  import Lucia.Controller

  setup do
    State.start_link
          
    on_exit fn ->
      State.reset
    end

    :ok
  end

  test "should not increment threshold when level is above 0.1" do
    check %{date: "2015-09-03T17:55:03Z", level: 0.13}

    assert State.get == %{threshold: 0, triggered: false}
  end
  
  test "should increment threshold when level is below 0.1" do
    check %{date: "2015-09-02T17:10:03Z", level: 0.055}

    assert State.get == %{threshold: 1, triggered: false}
  end

  test "should not increment threshold if already triggered" do
    State.trigger
    check %{date: "2015-09-02T17:10:03Z", level: 0.042}

    assert State.get == %{threshold: 0, triggered: true}
  end

  test "should not reset threshold if level goes back above 0.1" do
    check %{date: "2015-09-02T17:10:03Z", level: 0.042}
    assert State.get == %{threshold: 1, triggered: false}

    check %{date: "2015-09-02T17:10:03Z", level: 0.042}
    assert State.get == %{threshold: 2, triggered: false}

    check %{date: "2015-09-02T17:10:03Z", level: 0.14}
    assert State.get == %{threshold: 0, triggered: false}
  end

  test "should trigger after receiving 4 events with level below 0.1" do
    check %{date: "2015-09-02T17:10:03Z", level: 0.055}
    assert State.get == %{threshold: 1, triggered: false}
    
    check %{date: "2015-09-02T17:10:03Z", level: 0.055}
    assert State.get == %{threshold: 2, triggered: false}
    
    check %{date: "2015-09-02T17:10:03Z", level: 0.055}
    assert State.get == %{threshold: 3, triggered: false}
    
    check %{date: "2015-09-02T17:10:03Z", level: 0.055}
    assert State.get == %{threshold: 4, triggered: true}
  end

  test "should not trigger after 23:00" do
    check %{date: "2015-09-02T20:10:03Z", level: 0.055}
    assert State.get == %{threshold: 1, triggered: false}
    
    check %{date: "2015-09-02T21:10:03Z", level: 0.055}
    assert State.get == %{threshold: 2, triggered: false}
    
    check %{date: "2015-09-02T22:10:03Z", level: 0.055}
    assert State.get == %{threshold: 3, triggered: false}
    
    check %{date: "2015-09-02T23:10:03Z", level: 0.055}
    assert State.get == %{threshold: 4, triggered: false}

    check %{date: "2015-09-02T23:33:03Z", level: 0.055}
    assert State.get == %{threshold: 5, triggered: false}
  end

  test "should not trigger if started after 23:00" do
    check %{date: "2015-09-02T23:33:03Z", level: 0.055}
    assert State.get == %{threshold: 1, triggered: false}

    check %{date: "2015-09-02T23:38:03Z", level: 0.055}
    assert State.get == %{threshold: 2, triggered: false}

    check %{date: "2015-09-02T23:43:03Z", level: 0.055}
    assert State.get == %{threshold: 3, triggered: false}

    check %{date: "2015-09-02T23:48:03Z", level: 0.055}
    assert State.get == %{threshold: 4, triggered: false}

    check %{date: "2015-09-02T23:53:03Z", level: 0.055}
    assert State.get == %{threshold: 5, triggered: false}

    check %{date: "2015-09-02T23:58:03Z", level: 0.055}
    assert State.get == %{threshold: 6, triggered: false}
  end

  test "should reset state after 12:00 and level above 0.1" do
    check %{date: "2015-09-02T17:10:03Z", level: 0.055}
    assert State.get == %{threshold: 1, triggered: false}
    
    check %{date: "2015-09-02T17:10:03Z", level: 0.055}
    assert State.get == %{threshold: 2, triggered: false}
    
    check %{date: "2015-09-02T17:10:03Z", level: 0.055}
    assert State.get == %{threshold: 3, triggered: false}
    
    check %{date: "2015-09-02T17:10:03Z", level: 0.055}
    assert State.get == %{threshold: 4, triggered: true}

    check %{date: "2015-09-03T12:07:03Z", level: 0.15}
    assert State.get == %{threshold: 0, triggered: false}
  end
end
