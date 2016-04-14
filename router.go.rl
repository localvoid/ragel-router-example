package main

%% machine router;
%% write data;

func resolvePath(data string) (string, []string) {
	var handler string
	var params []string
	var mark int

	cs, p, pe, eof := 0, 0, len(data), len(data)

	%%{
		action mark { mark = p }
		action captureParam { params = append(params, data[mark:p]) }

		param = [^/]+ >mark %captureParam;
		wildcardParam = any+ >mark %captureParam;

    userHandlers = (
				param "/profile" @{ handler = "userProfile" }
			| param @{ handler = "user" }
    );

		main := (
				"/signup" @{ handler = "signup" }
			| "/login" @{ handler = "login" }
      | "/user/" userHandlers
      | "/articles/" wildcardParam @{ handler = "article" }
			| "/js/" @{ handler = "static" } any+
			| "/css/" @{ handler = "static" } any+
			| "/" %eof{ handler = "home" }
		);

		write init;
		write exec;
	}%%

	if cs < router_first_final {
		return "", nil
	}

	return handler, params
}