defmodule GlauthWeb.Utils.ResponseUtil do
  def error_message_response(message) do
    %{
      error: %{
        message: message
      }
    }
  end

  def success_message_response(data) do
    %{
      data: %{
        message: data
      }
    }
  end

  def success_data_response(data) do
    %{
      data: data
    }
  end
end
