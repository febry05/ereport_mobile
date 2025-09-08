<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Daftar Inventory - APS SUPPORT</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    @livewireStyles
    <link rel="stylesheet" href="{{ asset('css/style.css') }}">
</head>
<body>
    <nav class="navbar navbar-expand-lg nav-container py-2">
        <div class="container">
            <span class="navbar-brand">
                <img src="{{ asset('images/IAS_SUPPORT.png') }}" alt="IAS Logo" class="logo">
                Angkasa Pura Support
            </span>

            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse mt-3 mt-lg-0" id="mainNavbar">
                <ul class="nav nav-pills ms-lg-4 flex-column flex-lg-row">
                    <li class="nav-item me-lg-3">
                        <a class="nav-link" href="{{ route('admin.dashboard') }}">Home</a>
                    </li>
                    <li class="nav-item dropdown me-lg-3">
                        <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button">Users</a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="{{ route('teknisi.index') }}">Teknisi</a></li>
                            <li><a class="dropdown-item" href="{{ route('pic.index') }}">PIC</a></li>
                            <li><a class="dropdown-item" href="{{ route('klien.index') }}">Klien</a></li>
                        </ul>
                    </li>
                    <li class="nav-item me-lg-3">
                        <a class="nav-link active" href="{{ route('inventory.index') }}">Inventory</a>
                    </li>
                </ul>

                <form action="{{ route('logout') }}" method="POST" class="ms-auto mt-3 mt-lg-0">
                    @csrf
                    <button type="submit" class="btn btn-logout">Logout</button>
                </form>
            </div>
        </div>
    </nav>

    <div class="container py-5">
        <h3>Daftar Inventory</h3>

        {{-- Livewire Component --}}
        @livewire('inventory-component')
    </div>

    @livewireScripts
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
