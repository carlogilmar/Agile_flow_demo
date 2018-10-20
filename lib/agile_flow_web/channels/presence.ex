defmodule AgileFlowWeb.Presence do
  use Phoenix.Presence, otp_app: :agile_flow,
                        pubsub_server: AgileFlow.PubSub
end
