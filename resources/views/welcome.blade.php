<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>IAS SUPPORT</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    {{-- Bootstrap 5 CDN --}}
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(to bottom right, #18346eff, #0584c3ff);
            color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .nav-container {
            background-color: #ffffff;
            padding: 0.5rem 0;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .nav-pills .nav-link {
            color: #00B7C7;
            font-weight: 500;
        }

        .nav-pills .nav-link.active {
            background-color: #00B7C7;
            color: #ffffff;
        }

        .dropdown-menu {
            background-color: #ffffff;
            border: none;
            border-radius: 20px;
        }

        .dropdown-item {
            color: #000000;
        }

        .dropdown-item:hover {
            background-color: #00B7C7;
            color: #ffffff;
        }

        .btn-login {
            background-color: #D32F2F;
            color: white;
            font-weight: 500;
        }

        .btn-login:hover {
            background-color: #a42323ff;
            color: #ffffff;
        }

        .logo {
            height: 40px;
            margin-right: 10px;
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            color: #083F83;
            font-weight: bold;
            font-size: 1.25rem;
            text-decoration: none;
        }

        .navbar-brand:hover {
            color: #00B7C7;
        }

        .modal-content {
            background-color: rgba(255, 255, 255, 0.95);
            color: #000;
        }
    </style>
</head>
<body>

    {{-- 🔹 NAVBAR SECTION --}}
    <div class="nav-container">
        <div class="container d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center">
                <a href="https://angkasapurasolusi.co.id/" class="navbar-brand">
                    <img src="{{ asset('images/IAS_SUPPORT.png') }}" alt="IAS Logo" class="logo">
                    Angkasa Pura Support
                </a>
            </div>

            <button type="button" class="btn btn-login" data-bs-toggle="modal" data-bs-target="#loginModal">
                Login
            </button>
        </div>
    </div>

    <div class="container py-4">
    </div>

    <div class="modal fade" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content rounded-4 shadow-lg">
                <div class="modal-header">
                    <h5 class="modal-title" id="loginModalLabel">Login IAS SUPPORT</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Tutup"></button>
                </div>
                <div class="modal-body">
                    <form method="POST" action="{{ route('login') }}">
                        @csrf
                        <div class="mb-3">
                            <label for="email" class="form-label">Username</label>
                            <input type="text" class="form-control" id="email" name="email" required autofocus>
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>

                        <button type="submit" class="btn btn-primary w-100">Masuk</button>

                        @if ($errors->any())
                            <div class="alert alert-danger mt-3 text-center">
                                {{ $errors->first() }}
                            </div>
                        @endif
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
