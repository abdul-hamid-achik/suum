#!/bin/bash
mix ecto.migrate
MIX_ENV=${MIX_ENV:-prod} exec mix phx.server