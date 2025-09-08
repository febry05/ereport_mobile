<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Daftar Teknisi - APS SUPPORT</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="{{ asset('css/style.css') }}" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
</head>
<body>
    <nav class="navbar navbar-expand-lg nav-container py-2">
        <div class="container">
            <span class="navbar-brand">
                <img src="{{ asset('images/IAS_SUPPORT.png') }}" alt="IAS Logo" class="logo" />
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
                        <a class="nav-link" href="{{ route('inventory.index') }}">Inventory</a>
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
        <h3>Daftar Teknisi</h3>

        {{-- Alert Sukses --}}
        @if (session()->has('success'))
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> {{ session('success') }}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        @endif

        {{-- Filter dan tombol tambah --}}
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
            <button class="btn shadow-sm custom-btn" data-bs-toggle="modal" data-bs-target="#addModal">
                <i class="bi bi-plus-circle me-1"></i> Tambah Teknisi
            </button>

            <form method="GET" action="{{ route('teknisi.index') }}" class="d-flex gap-2 mt-2 mt-md-0">
                <div class="input-group shadow-sm">
                    <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                    <input
                        type="text"
                        name="search"
                        value="{{ request('search') }}"
                        class="form-control"
                        placeholder="Cari nama teknisi..."
                    />
                </div>
                <select name="filterDivisi" class="form-select shadow-sm select-merah">
                    <option value="">Semua Divisi</option>
                    @foreach($divisiList as $divisi)
                        <option value="{{ $divisi->id_divisi }}" @selected(request('filterDivisi') == $divisi->id_divisi)>
                            {{ $divisi->nama_divisi }}
                        </option>
                    @endforeach
                </select>
                <button type="submit" class="btn btn-outline-danger shadow-sm">Filter</button>
            </form>
        </div>

        {{-- Tabel teknisi --}}
        <div class="table-responsive shadow-sm rounded">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-success">
                    <tr>
                        <th style="width:5%">No</th>
                        <th>Nama Teknisi</th>
                        <th>NIP</th>
                        <th>Divisi</th>
                        <th style="width:20%" class="text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse ($teknisi as $index => $item)
                        <tr>
                            <td>{{ $teknisi->firstItem() + $index }}</td>
                            <td class="fw-semibold">{{ $item->nama_teknisi }}</td>
                            <td>{{ $item->nip }}</td>
                            <td>{{ $item->divisi->nama_divisi ?? '-' }}</td>
                            <td class="text-center">
                                <div class="btn-group" role="group" aria-label="Aksi Teknisi">
                                    <button
                                        class="btn btn-info btn-sm"
                                        data-bs-toggle="modal"
                                        data-bs-target="#detailModal"
                                        data-id="{{ $item->id_teknisi }}"
                                        data-nama="{{ $item->nama_teknisi }}"
                                        data-nip="{{ $item->nip }}"
                                        data-notlp="{{ $item->notlp_teknisi }}"
                                        data-alamat="{{ $item->alamat_teknisi }}"
                                        data-divisi="{{ $item->divisi->nama_divisi ?? '-' }}"
                                        data-email="{{ $item->user->email ?? '-' }}"
                                        title="Detail"
                                    >
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <button
                                        class="btn btn-warning btn-sm"
                                        data-bs-toggle="modal"
                                        data-bs-target="#editModal"
                                        data-id="{{ $item->id_teknisi }}"
                                        data-nama="{{ $item->nama_teknisi }}"
                                        data-nip="{{ $item->nip }}"
                                        data-notlp="{{ $item->notlp_teknisi }}"
                                        data-alamat="{{ $item->alamat_teknisi }}"
                                        data-divisi="{{ $item->id_divisi }}"
                                        title="Edit"
                                    >
                                        <i class="bi bi-pencil-square"></i>
                                    </button>
                                    <button
                                        class="btn btn-danger btn-sm"
                                        data-bs-toggle="modal"
                                        data-bs-target="#hapusModal"
                                        data-id="{{ $item->id_teknisi }}"
                                        data-nama="{{ $item->nama_teknisi }}"
                                        title="Hapus"
                                    >
                                        <i class="bi bi-trash3"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="5" class="text-center text-muted py-3">Tidak ada data</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        {{-- Pagination --}}
        <div class="mt-3 d-flex justify-content-between align-items-center">
            <a href="{{ $teknisi->previousPageUrl() }}"
            class="btn btn-pagination btn-sm @if($teknisi->onFirstPage()) disabled @endif"
            @if($teknisi->onFirstPage()) tabindex="-1" aria-disabled="true" @endif>
            &larr; Prev
            </a>
            <span class="text-muted small">
                Halaman {{ $teknisi->currentPage() }} dari {{ $teknisi->lastPage() }}
            </span>
            <a href="{{ $teknisi->nextPageUrl() }}"
            class="btn btn-pagination btn-sm @if(!$teknisi->hasMorePages()) disabled @endif"
            @if(!$teknisi->hasMorePages()) tabindex="-1" aria-disabled="true" @endif>
            Next &rarr;
            </a>
        </div>
    </div>

    {{-- Modal Tambah Teknisi --}}
    <div class="modal fade" id="addModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <form method="POST" action="{{ route('teknisi.store') }}" class="modal-content shadow-lg border-0 rounded-3">
                @csrf
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title"><i class="bi bi-plus-circle me-2"></i>Tambah Teknisi</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Project</label>
                        <select name="id_divisi" class="form-select shadow-sm" required>
                            <option value="">-- Pilih Project --</option>
                            @foreach($divisiList as $divisi)
                                <option value="{{ $divisi->id_divisi }}" @selected(old('id_divisi') == $divisi->id_divisi)>{{ $divisi->nama_divisi }}</option>
                            @endforeach
                        </select>
                        @error('id_divisi') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nama Teknisi</label>
                        <input type="text" name="nama_teknisi" class="form-control shadow-sm" value="{{ old('nama_teknisi') }}" required />
                        @error('nama_teknisi') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">NIP</label>
                        <input type="number" name="nip" class="form-control shadow-sm" value="{{ old('nip') }}" required />
                        @error('nip') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nomor Telepon</label>
                        <input type="number" name="notlp_teknisi" class="form-control shadow-sm" value="{{ old('notlp_teknisi') }}" required />
                        @error('notlp_teknisi') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Alamat</label>
                        <textarea name="alamat_teknisi" class="form-control shadow-sm" required>{{ old('alamat_teknisi') }}</textarea>
                        @error('alamat_teknisi') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control shadow-sm" value="{{ old('email') }}" required />
                        @error('email') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div>
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-control shadow-sm" required />
                        @error('password') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-save me-1"></i> Simpan
                    </button>
                </div>
            </form>
        </div>
    </div>

    {{-- Modal Detail Teknisi --}}
    <div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg border-0 rounded-3">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title"><i class="bi bi-info-circle me-2"></i>Detail Teknisi</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p><strong>Nama Teknisi:</strong> <span id="detailNama"></span></p>
                    <p><strong>NIP:</strong> <span id="detailNip"></span></p>
                    <p><strong>Divisi:</strong> <span id="detailDivisi"></span></p>
                    <p><strong>Nomor Telepon:</strong> <span id="detailNotlp"></span></p>
                    <p><strong>Alamat:</strong> <span id="detailAlamat"></span></p>
                    <p><strong>Email:</strong> <span id="detailEmail"></span></p>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
                </div>
            </div>
        </div>
    </div>

    {{-- Modal Edit Teknisi --}}
    <div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <form method="POST" id="editForm" class="modal-content shadow-lg border-0 rounded-3">
                @csrf
                @method('PUT')
                <div class="modal-header bg-warning">
                    <h5 class="modal-title text-dark"><i class="bi bi-pencil-square me-2"></i>Edit Teknisi</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="id_teknisi" id="edit_id_teknisi" />
                    <div class="mb-3">
                        <label class="form-label">Nama Teknisi</label>
                        <input type="text" name="nama_teknisi" id="edit_nama_teknisi" class="form-control shadow-sm" required />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">NIP</label>
                        <input type="text" name="nip" id="edit_nip" class="form-control shadow-sm" required />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nomor Telepon</label>
                        <input type="text" name="notlp_teknisi" id="edit_notlp_teknisi" class="form-control shadow-sm" required />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Alamat Teknisi</label>
                        <textarea name="alamat_teknisi" id="edit_alamat_teknisi" class="form-control shadow-sm" required></textarea>
                    </div>
                    <div>
                        <label class="form-label">Project</label>
                        <select name="id_divisi" id="edit_id_divisi" class="form-select shadow-sm" required>
                            <option value="">-- Pilih Project --</option>
                            @foreach($divisiList as $divisi)
                                <option value="{{ $divisi->id_divisi }}">{{ $divisi->nama_divisi }}</option>
                            @endforeach
                        </select>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="submit" class="btn btn-warning text-dark">
                        <i class="bi bi-save me-1"></i> Update
                    </button>
                </div>
            </form>
        </div>
    </div>

    {{-- Modal Hapus Teknisi --}}
    <div class="modal fade" id="hapusModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <form method="POST" id="hapusForm" class="modal-content shadow-lg border-0 rounded-3">
                @csrf
                @method('DELETE')
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">
                        <i class="bi bi-exclamation-triangle me-2"></i>Konfirmasi Hapus
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <p class="mb-4">
                        Apakah Anda yakin ingin menghapus data <strong id="hapusNamaTeknisi"></strong>?
                    </p>
                    <button type="submit" class="btn btn-danger me-2">
                        <i class="bi bi-trash3 me-1"></i> Hapus
                    </button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        const detailModal = document.getElementById('detailModal');
        detailModal.addEventListener('show.bs.modal', event => {
            const button = event.relatedTarget;

            document.getElementById('detailNama').textContent = button.getAttribute('data-nama');
            document.getElementById('detailNip').textContent = button.getAttribute('data-nip');
            document.getElementById('detailDivisi').textContent = button.getAttribute('data-divisi');
            document.getElementById('detailNotlp').textContent = button.getAttribute('data-notlp');
            document.getElementById('detailAlamat').textContent = button.getAttribute('data-alamat');
            document.getElementById('detailEmail').textContent = button.getAttribute('data-email');
        });
        
        // Isi modal edit dengan data tombol yang dipilih
        const editModal = document.getElementById('editModal');
        editModal.addEventListener('show.bs.modal', event => {
            const button = event.relatedTarget;
            const id = button.getAttribute('data-id');
            const nama = button.getAttribute('data-nama');
            const nip = button.getAttribute('data-nip');
            const notlp = button.getAttribute('data-notlp');
            const alamat = button.getAttribute('data-alamat');
            const divisi = button.getAttribute('data-divisi');

            const form = document.getElementById('editForm');
            form.action = `/teknisi/${id}`;

            document.getElementById('edit_id_teknisi').value = id;
            document.getElementById('edit_nama_teknisi').value = nama;
            document.getElementById('edit_nip').value = nip;
            document.getElementById('edit_notlp_teknisi').value = notlp;
            document.getElementById('edit_alamat_teknisi').value = alamat;
            document.getElementById('edit_id_divisi').value = divisi;
        });

        // Isi modal hapus dengan data tombol yang dipilih
        const hapusModal = document.getElementById('hapusModal');
        hapusModal.addEventListener('show.bs.modal', event => {
            const button = event.relatedTarget;
            const id = button.getAttribute('data-id');
            const nama = button.getAttribute('data-nama');

            const form = document.getElementById('hapusForm');
            form.action = `/teknisi/${id}`;

            document.getElementById('hapusNamaTeknisi').textContent = nama;
        });
    </script>
</body>
</html>
