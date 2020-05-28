# Data Formats

#### Repeats = 2
```text
Success: true

Values: 
[   *** EXISTING (3) ***
    #<SknSuccess:0x00007fb8a8876190 @value=
        [
            [
                #<SknSuccess:0x00007fb8888976a8 @value={"token"=>"eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1OTA2ODE3MTIsImlhdCI6MTU5MDY3ODExMiwibmJmIjoxNTkwNjc0NTEyLCJpc3MiOiJza29vbmEubmV0IiwiYXVkIjpbIkludGVybmFsVXNlT25seSJdLCJzdWIiOiJlbW93bmVyIiwic2NvcGVzIjpbImFkZF9tb25leSIsInZpZXdfbW9uZXkiLCJyZW1vdmVfbW9uZXkiXSwidXNlciI6eyJ1c2VybmFtZSI6ImVtb3duZXIifX0.Jq0w8z8lJbDC_W0peMFen0Tyhqqdp6MKjLgZYoApLwE"}, @message="Net::HTTPOK", @success=true>, 
                [
                    #<SknSuccess:0x00007fb8888c7b00 @value={"money"=>100240}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb8a886f098 @value={"money"=>100340}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb8a88c9ef8 @value={"money"=>100290}, @message="Net::HTTPOK", @success=true>
                ], 
                [
                    #<SknSuccess:0x00007fb8a88fb868 @value={"money"=>100290}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb88807b168 @value={"money"=>100390}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb8a890a818 @value={"money"=>100340}, @message="Net::HTTPOK", @success=true>
                ], 
                [
                    #<SknSuccess:0x00007fb8a8920488 @value={"money"=>100240}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb8a893b058 @value={"money"=>100240}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb8a8941a70 
                        @value={
                            "metrics"=>{
                                "ipl_timestamp"=>"2020-05-28 08:25:07.553541000 -0400", 
                                "timestamp"=>"2020-05-28 11:01:52.330533000 -0400", 
                                "app_version"=>"2.1.0", 
                                "active_environment"=>"development", 
                                "api_version"=>"v1", 
                                "registrations"=>50, 
                                "reg_failures"=>0, 
                                "unregisters"=>0, 
                                "unreg_failures"=>0, 
                                "authentications"=>76, 
                                "auth_failures"=>0, 
                                "not_found_failures"=>48, 
                                "account_transactions"=>14413, 
                                "credential_transactions"=>51, 
                                "api_view_money_requests"=>14110, 
                                "api_add_money_requests"=>14038, 
                                "api_remove_money_requests"=>14110, 
                                "uncaught_exceptions"=>0, 
                                "jwt_tokens_issued"=>76, 
                                "jwt_audience"=>["InternalUseOnly"], 
                                "credentials_storage"=>685, 
                                "accounts_storage"=>350
                             }
                        }, 
                        @message="Net::HTTPOK", 
                        @success=true
                    >
                ]
            ], 
            [
                #<SknSuccess:0x00007fb8a8963a80 @value={"token"=>"eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1OTA2ODE3MTIsImlhdCI6MTU5MDY3ODExMiwibmJmIjoxNTkwNjc0NTEyLCJpc3MiOiJza29vbmEubmV0IiwiYXVkIjpbIkludGVybmFsVXNlT25seSJdLCJzdWIiOiJlbWtlZXBlciIsInNjb3BlcyI6WyJhZGRfbW9uZXkiLCJ2aWV3X21vbmV5Il0sInVzZXIiOnsidXNlcm5hbWUiOiJlbWtlZXBlciJ9fQ.T40XVg3rC0poEFs0mYDWguiWQFhzZDgT7cCUpgfh7W0"}, @message="Net::HTTPOK", @success=true>, 
                [
                    #<SknSuccess:0x00007fb8a8980a90 @value={"money"=>171200}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb8a89924c0 @value={"money"=>171300}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb8a89a3ab8 @value="403", @message="Forbidden", @success=false>
                ], 
                [
                    #<SknSuccess:0x00007fb8a89b1730 @value={"money"=>171300}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb86801e640 @value={"money"=>171400}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb8680253a0 @value="403", @message="Forbidden", @success=false>
                ], 
                [
                    #<SknFailure:0x00007fb868040fb0 @value="403", @message="Forbidden", @success=false>, 
                    #<SknSuccess:0x00007fb868053638 @value={"money"=>171400}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb8a885fa58 
                        @value={
                            "metrics"=>{
                                "ipl_timestamp"=>"2020-05-28 08:25:07.553541000 -0400", 
                                "timestamp"=>"2020-05-28 11:01:52.354792000 -0400", 
                                "app_version"=>"2.1.0", 
                                "active_environment"=>"development", 
                                "api_version"=>"v1", 
                                "registrations"=>51, 
                                "reg_failures"=>0, 
                                "unregisters"=>0, 
                                "unreg_failures"=>0, 
                                "authentications"=>78, 
                                "auth_failures"=>0, 
                                "not_found_failures"=>49, 
                                "account_transactions"=>14418, 
                                "credential_transactions"=>52, 
                                "api_view_money_requests"=>14115, 
                                "api_add_money_requests"=>14042, 
                                "api_remove_money_requests"=>14115, 
                                "uncaught_exceptions"=>0, 
                                "jwt_tokens_issued"=>78, 
                                "jwt_audience"=>["InternalUseOnly"], 
                                "credentials_storage"=>685, 
                                "accounts_storage"=>348
                            }
                        }, 
                        @message="Net::HTTPOK", 
                        @success=true
                    >
                ]
            ], 
            [
                #<SknSuccess:0x00007fb8a89c2710 @value={"token"=>"eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1OTA2ODE3MTIsImlhdCI6MTU5MDY3ODExMiwibmJmIjoxNTkwNjc0NTEyLCJpc3MiOiJza29vbmEubmV0IiwiYXVkIjpbIkludGVybmFsVXNlT25seSJdLCJzdWIiOiJlbXVzZXIiLCJzY29wZXMiOlsidmlld19tb25leSJdLCJ1c2VyIjp7InVzZXJuYW1lIjoiZW11c2VyIn19.FJ8LPYFr__TDvXHtOjICpMSpmc66E3o25mSqb7iwRw8"}, @message="Net::HTTPOK", @success=true>, 
                [
                    #<SknSuccess:0x00007fb8a89c8ea8 @value={"money"=>50000}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb8a89e2858 @value="403", @message="Forbidden", @success=false>, 
                    #<SknFailure:0x00007fb8a89f13d0 @value="403", @message="Forbidden", @success=false>
                ], 
                [
                    #<SknSuccess:0x00007fb8a8a03760 @value={"money"=>50000}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb8b0122a58 @value="403", @message="Forbidden", @success=false>, 
                    #<SknFailure:0x00007fb88885d6b0 @value="403", @message="Forbidden", @success=false>
                ], 
                [
                    #<SknFailure:0x00007fb8888c5d28 @value="403", @message="Forbidden", @success=false>, 
                    #<SknSuccess:0x00007fb8a88591a8 @value={"money"=>50000}, @message="Net::HTTPOK", @success=true>,
                     
                    #<SknSuccess:0x00007fb8a8876230 
                        @value={
                            "metrics"=>{
                                "ipl_timestamp"=>"2020-05-28 08:25:07.553541000 -0400", 
                                "timestamp"=>"2020-05-28 11:01:52.377335000 -0400", 
                                "app_version"=>"2.1.0", 
                                "active_environment"=>"development", 
                                "api_version"=>"v1", 
                                "registrations"=>52, 
                                "reg_failures"=>0, 
                                "unregisters"=>0, 
                                "unreg_failures"=>0, 
                                "authentications"=>80, 
                                "auth_failures"=>0, 
                                "not_found_failures"=>50, 
                                "account_transactions"=>14420, 
                                "credential_transactions"=>53, 
                                "api_view_money_requests"=>14120, 
                                "api_add_money_requests"=>14045, 
                                "api_remove_money_requests"=>14119, 
                                "uncaught_exceptions"=>0, 
                                "jwt_tokens_issued"=>80, 
                                "jwt_audience"=>["InternalUseOnly"], 
                                "credentials_storage"=>685, 
                                "accounts_storage"=>346
                            }
                        }, 
                        @message="Net::HTTPOK", 
                        @success=true
                    >    
                ]
            ]
        ], 
        @message="", 
        @success=true
    >,
         
    *** NEW USERS (3) REPEATS [2] ***
    #<SknSuccess:0x00007fb8a8a09ac0 @value=
        [
            [
                #<SknSuccess:0x00007fb8888cc8a8 @value={"message"=>"Registered bmagent with [\"view_money\", \"add_money\"] Succeeded!"}, @message="Net::HTTPAccepted", @success=true>, 
                #<SknSuccess:0x00007fb8a88582d0 @value={"token"=>"eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1OTA2ODE3MTIsImlhdCI6MTU5MDY3ODExMiwibmJmIjoxNTkwNjc0NTEyLCJpc3MiOiJza29vbmEubmV0IiwiYXVkIjpbIkludGVybmFsVXNlT25seSJdLCJzdWIiOiJibWFnZW50Iiwic2NvcGVzIjpbInZpZXdfbW9uZXkiLCJhZGRfbW9uZXkiXSwidXNlciI6eyJ1c2VybmFtZSI6ImJtYWdlbnQifX0.85-kaF_kPuHpuoJBC0lv57IHsVSOubrAneB-UMAI0U4"}, @message="Net::HTTPOK", @success=true>, 
                [
                    #<SknSuccess:0x00007fb8a88a3bb8 @value={"money"=>0}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb8a88e0ec8 @value={"money"=>100}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb888063a68 @value="403", @message="Forbidden", @success=false>
                ], 
                [
                    #<SknSuccess:0x00007fb888069be8 @value={"money"=>100}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb8a8908b30 @value={"money"=>200}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb8a8919138 @value="403", @message="Forbidden", @success=false>
                ], 
                [
                    #<SknFailure:0x00007fb8a892a960 @value="403", @message="Forbidden", @success=false>, 
                    #<SknSuccess:0x00007fb8a8930f40 @value={"money"=>200}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb8a89598f0 @value="404", @message="Not Found", @success=false>,
                    #<SknSuccess:0x00007fb8a894b890 @value={"metrics"=>{"ipl_timestamp"=>"2020-05-28 08:25:07.553541000 -0400", "timestamp"=>"2020-05-28 11:01:52.330792000 -0400", "app_version"=>"2.1.0", "active_environment"=>"development", "api_version"=>"v1", "registrations"=>50, "reg_failures"=>0, "unregisters"=>0, "unreg_failures"=>0, "authentications"=>76, "auth_failures"=>0, "not_found_failures"=>48, "account_transactions"=>14413, "credential_transactions"=>51, "api_view_money_requests"=>14110, "api_add_money_requests"=>14038, "api_remove_money_requests"=>14110, "uncaught_exceptions"=>0, "jwt_tokens_issued"=>76, "jwt_audience"=>["InternalUseOnly"], "credentials_storage"=>685, "accounts_storage"=>350}}, @message="Net::HTTPOK", @success=true> 
                ]
            ], 
            [
                #<SknSuccess:0x00007fb888089948 @value={"message"=>"Registered bmproducer with [\"view_money\", \"add_money\"] Succeeded!"}, @message="Net::HTTPAccepted", @success=true>, 
                #<SknSuccess:0x00007fb8a89a1b28 @value={"token"=>"eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1OTA2ODE3MTIsImlhdCI6MTU5MDY3ODExMiwibmJmIjoxNTkwNjc0NTEyLCJpc3MiOiJza29vbmEubmV0IiwiYXVkIjpbIkludGVybmFsVXNlT25seSJdLCJzdWIiOiJibXByb2R1Y2VyIiwic2NvcGVzIjpbInZpZXdfbW9uZXkiLCJhZGRfbW9uZXkiXSwidXNlciI6eyJ1c2VybmFtZSI6ImJtcHJvZHVjZXIifX0.7uwXy6vTm4cMN82qrYa6MGZ4hw66AjMHtOrCftm0rIs"}, @message="Net::HTTPOK", @success=true>, 
                [
                    #<SknSuccess:0x00007fb868017b10 @value={"money"=>0}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb86800c300 @value={"money"=>100}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb86802d528 @value="403", @message="Forbidden", @success=false>
                ], 
                [
                    #<SknSuccess:0x00007fb868039e90 @value={"money"=>100}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb868051b08 @value={"money"=>200}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb888091f30 @value="403", @message="Forbidden", @success=false>
                ], 
                [
                    #<SknFailure:0x00007fb8a89b8878 @value="403", @message="Forbidden", @success=false>, 
                    #<SknSuccess:0x00007fb8a89d3128 @value={"money"=>200}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb8a89f32e8 @value="404", @message="Not Found", @success=false>,
                    #<SknSuccess:0x00007fb8a89d8560 @value={"metrics"=>{"ipl_timestamp"=>"2020-05-28 08:25:07.553541000 -0400", "timestamp"=>"2020-05-28 11:01:52.360526000 -0400", "app_version"=>"2.1.0", "active_environment"=>"development", "api_version"=>"v1", "registrations"=>51, "reg_failures"=>0, "unregisters"=>0, "unreg_failures"=>0, "authentications"=>79, "auth_failures"=>0, "not_found_failures"=>49, "account_transactions"=>14418, "credential_transactions"=>52, "api_view_money_requests"=>14117, "api_add_money_requests"=>14042, "api_remove_money_requests"=>14116, "uncaught_exceptions"=>0, "jwt_tokens_issued"=>79, "jwt_audience"=>["InternalUseOnly"], "credentials_storage"=>685, "accounts_storage"=>348}}, @message="Net::HTTPOK", @success=true> 
                ]
            ], 
            [
                #<SknSuccess:0x00007fb8a8a0a330 @value={"message"=>"Registered bmartist with [\"view_money\", \"add_money\"] Succeeded!"}, @message="Net::HTTPAccepted", @success=true>, 
                #<SknSuccess:0x00007fb88886e050 @value={"token"=>"eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1OTA2ODE3MTIsImlhdCI6MTU5MDY3ODExMiwibmJmIjoxNTkwNjc0NTEyLCJpc3MiOiJza29vbmEubmV0IiwiYXVkIjpbIkludGVybmFsVXNlT25seSJdLCJzdWIiOiJibWFydGlzdCIsInNjb3BlcyI6WyJ2aWV3X21vbmV5IiwiYWRkX21vbmV5Il0sInVzZXIiOnsidXNlcm5hbWUiOiJibWFydGlzdCJ9fQ.rB-Vzz4uM_cRjR8-QEo8beDAx0wV4PXIMY01xNY1MZc"}, @message="Net::HTTPOK", @success=true>, 
                [
                    #<SknSuccess:0x00007fb8888d6060 @value={"money"=>0}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb8a886fa70 @value={"money"=>100}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb8a8898d30 @value="403", @message="Forbidden", @success=false>
                ], 
                [
                    #<SknSuccess:0x00007fb8a88c3b70 @value={"money"=>100}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb8a88e24a8 @value={"money"=>200}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb888041800 @value="403", @message="Forbidden", @success=false>
                ], 
                [
                    #<SknFailure:0x00007fb888063f18 @value="403", @message="Forbidden", @success=false>,
                    #<SknSuccess:0x00007fb888069f80 @value={"money"=>200}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb8a890ba60 @value="404", @message="Not Found", @success=false>,
                    #<SknSuccess:0x00007fb888079318 @value={"metrics"=>{"ipl_timestamp"=>"2020-05-28 08:25:07.553541000 -0400", "timestamp"=>"2020-05-28 11:01:52.389557000 -0400", "app_version"=>"2.1.0", "active_environment"=>"development", "api_version"=>"v1", "registrations"=>52, "reg_failures"=>0, "unregisters"=>0, "unreg_failures"=>0, "authentications"=>80, "auth_failures"=>0, "not_found_failures"=>50, "account_transactions"=>14421, "credential_transactions"=>53, "api_view_money_requests"=>14122, "api_add_money_requests"=>14046, "api_remove_money_requests"=>14122, "uncaught_exceptions"=>0, "jwt_tokens_issued"=>80, "jwt_audience"=>["InternalUseOnly"], "credentials_storage"=>685, "accounts_storage"=>346}}, @message="Net::HTTPOK", @success=true> 
                ]
            ], 
            [
                #<SknSuccess:0x00007fb8a8913260 @value={"message"=>"Registered bmagent with [\"view_money\", \"add_money\"] Succeeded!"}, @message="Net::HTTPAccepted", @success=true>, 
                #<SknSuccess:0x00007fb8a8919d68 @value={"token"=>"eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1OTA2ODE3MTIsImlhdCI6MTU5MDY3ODExMiwibmJmIjoxNTkwNjc0NTEyLCJpc3MiOiJza29vbmEubmV0IiwiYXVkIjpbIkludGVybmFsVXNlT25seSJdLCJzdWIiOiJibWFnZW50Iiwic2NvcGVzIjpbInZpZXdfbW9uZXkiLCJhZGRfbW9uZXkiXSwidXNlciI6eyJ1c2VybmFtZSI6ImJtYWdlbnQifX0.85-kaF_kPuHpuoJBC0lv57IHsVSOubrAneB-UMAI0U4"}, @message="Net::HTTPOK", @success=true>, 
                [
                    #<SknSuccess:0x00007fb8a8921108 @value={"money"=>0}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb8a8928c50 @value={"money"=>100}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb8a893b5f8 @value="403", @message="Forbidden", @success=false>
                ], 
                [
                    #<SknSuccess:0x00007fb8a8943af0 @value={"money"=>100}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb8a894adc8 @value={"money"=>200}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb8a8950b88 @value="403", @message="Forbidden", @success=false>
                ], 
                [
                    #<SknFailure:0x00007fb8a8962658 @value="403", @message="Forbidden", @success=false>, 
                    #<SknSuccess:0x00007fb8a8970500 @value={"money"=>200}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb888088f70 @value="404", @message="Not Found", @success=false>,
                    #<SknSuccess:0x00007fb8a898a130 @value={"metrics"=>{"ipl_timestamp"=>"2020-05-28 08:25:07.553541000 -0400", "timestamp"=>"2020-05-28 11:01:52.414740000 -0400", "app_version"=>"2.1.0", "active_environment"=>"development", "api_version"=>"v1", "registrations"=>53, "reg_failures"=>0, "unregisters"=>0, "unreg_failures"=>0, "authentications"=>81, "auth_failures"=>0, "not_found_failures"=>51, "account_transactions"=>14424, "credential_transactions"=>54, "api_view_money_requests"=>14125, "api_add_money_requests"=>14048, "api_remove_money_requests"=>14125, "uncaught_exceptions"=>0, "jwt_tokens_issued"=>81, "jwt_audience"=>["InternalUseOnly"], "credentials_storage"=>685, "accounts_storage"=>346}}, @message="Net::HTTPOK", @success=true> 
                ]
            ], 
            [
                #<SknSuccess:0x00007fb8a899b0c0 @value={"message"=>"Registered bmproducer with [\"view_money\", \"add_money\"] Succeeded!"}, @message="Net::HTTPAccepted", @success=true>, 
                #<SknSuccess:0x00007fb8a89a2c80 @value={"token"=>"eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1OTA2ODE3MTIsImlhdCI6MTU5MDY3ODExMiwibmJmIjoxNTkwNjc0NTEyLCJpc3MiOiJza29vbmEubmV0IiwiYXVkIjpbIkludGVybmFsVXNlT25seSJdLCJzdWIiOiJibXByb2R1Y2VyIiwic2NvcGVzIjpbInZpZXdfbW9uZXkiLCJhZGRfbW9uZXkiXSwidXNlciI6eyJ1c2VybmFtZSI6ImJtcHJvZHVjZXIifX0.7uwXy6vTm4cMN82qrYa6MGZ4hw66AjMHtOrCftm0rIs"}, @message="Net::HTTPOK", @success=true>, 
                [
                    #<SknSuccess:0x00007fb8a89b3cd8 @value={"money"=>0}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb868017660 @value={"money"=>100}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb86800e5d8 @value="403", @message="Forbidden", @success=false>
                ], 
                [
                    #<SknSuccess:0x00007fb86801f220 @value={"money"=>100}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb86802e360 @value={"money"=>200}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb868025d00 @value="403", @message="Forbidden", @success=false>
                ], 
                [
                    #<SknFailure:0x00007fb868038f40 @value="403", @message="Forbidden", @success=false>, 
                    #<SknSuccess:0x00007fb868041a28 @value={"money"=>200}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb868052300 @value="404", @message="Not Found", @success=false>,
                    #<SknSuccess:0x00007fb86804a358 @value={"metrics"=>{"ipl_timestamp"=>"2020-05-28 08:25:07.553541000 -0400", "timestamp"=>"2020-05-28 11:01:52.435969000 -0400", "app_version"=>"2.1.0", "active_environment"=>"development", "api_version"=>"v1", "registrations"=>54, "reg_failures"=>0, "unregisters"=>0, "unreg_failures"=>0, "authentications"=>82, "auth_failures"=>0, "not_found_failures"=>52, "account_transactions"=>14427, "credential_transactions"=>55, "api_view_money_requests"=>14128, "api_add_money_requests"=>14050, "api_remove_money_requests"=>14128, "uncaught_exceptions"=>0, "jwt_tokens_issued"=>82, "jwt_audience"=>["InternalUseOnly"], "credentials_storage"=>685, "accounts_storage"=>346}}, @message="Net::HTTPOK", @success=true> 
                ]
            ], 
            [
                #<SknSuccess:0x00007fb868058278 @value={"message"=>"Registered bmartist with [\"view_money\", \"add_money\"] Succeeded!"}, @message="Net::HTTPAccepted", @success=true>, 
                #<SknSuccess:0x00007fb8a885ea68 @value={"token"=>"eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1OTA2ODE3MTIsImlhdCI6MTU5MDY3ODExMiwibmJmIjoxNTkwNjc0NTEyLCJpc3MiOiJza29vbmEubmV0IiwiYXVkIjpbIkludGVybmFsVXNlT25seSJdLCJzdWIiOiJibWFydGlzdCIsInNjb3BlcyI6WyJ2aWV3X21vbmV5IiwiYWRkX21vbmV5Il0sInVzZXIiOnsidXNlcm5hbWUiOiJibWFydGlzdCJ9fQ.rB-Vzz4uM_cRjR8-QEo8beDAx0wV4PXIMY01xNY1MZc"}, @message="Net::HTTPOK", @success=true>, 
                [
                    #<SknSuccess:0x00007fb8a89b9ca0 @value={"money"=>0}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb8a89c0c80 @value={"money"=>100}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb8a89c8980 @value="403", @message="Forbidden", @success=false>
                ], 
                [
                    #<SknSuccess:0x00007fb8a89d0860 @value={"money"=>100}, @message="Net::HTTPOK", @success=true>, 
                    #<SknSuccess:0x00007fb8a89e3ed8 @value={"money"=>200}, @message="Net::HTTPOK", @success=true>, 
                    #<SknFailure:0x00007fb8a89eb480 @value="403", @message="Forbidden", @success=false>
                ],         
                [
                    #<SknFailure:0x00007fb8a89f2708 @value="403", @message="Forbidden", @success=false>, 
                    #<SknSuccess:0x00007fb8a89fac28 @value={"money"=>200}, @message="Net::HTTPOK", @success=true>,         
                    #<SknFailure:0x00007fb8a8a09b38 @value="404", @message="Not Found", @success=false>,
                    #<SknSuccess:0x00007fb8a8a035f8 @value={"metrics"=>{"ipl_timestamp"=>"2020-05-28 08:25:07.553541000 -0400", "timestamp"=>"2020-05-28 11:01:52.456236000 -0400", "app_version"=>"2.1.0", "active_environment"=>"development", "api_version"=>"v1", "registrations"=>55, "reg_failures"=>0, "unregisters"=>0, "unreg_failures"=>0, "authentications"=>83, "auth_failures"=>0, "not_found_failures"=>53, "account_transactions"=>14430, "credential_transactions"=>56, "api_view_money_requests"=>14131, "api_add_money_requests"=>14052, "api_remove_money_requests"=>14131, "uncaught_exceptions"=>0, "jwt_tokens_issued"=>83, "jwt_audience"=>["InternalUseOnly"], "credentials_storage"=>685, "accounts_storage"=>346}}, @message="Net::HTTPOK", @success=true> 
                ]
            ]
        ], 
        @message="", 
        @success=true
    >
]
Messages: ["", ""]

```