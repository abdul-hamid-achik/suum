#!/bin/bash
mix ecto.migrate
exec mix phx.server