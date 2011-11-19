# Be sure to restart your server when you modify this file.

Plague::Application.config.session_store :cookie_store, key: '_plague_session',
                                                        expire_after: 1.year
