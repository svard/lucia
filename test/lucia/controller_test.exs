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
end