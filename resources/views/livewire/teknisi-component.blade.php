<div>
    {{-- Alert Sukses --}}
    @if (session()->has('success'))
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> {{ session('success') }}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    @endif

    {{-- Header: Tombol Tambah & Search/Filter --}}
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
        <button class="btn shadow-sm custom-btn" data-bs-toggle="modal" data-bs-target="#addModal">
            <i class="bi bi-plus-circle me-1"></i> Tambah Teknisi
        </button>

        @if ($teknisi->currentPage() == 1)
            <form method="GET" action="{{ route('teknisi.index') }}" class="d-flex gap-2 mt-2 mt-md-0">
                <div class="input-group shadow-sm">
                    <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                    <input
                        type="text"
                        name="search"
                        value="{{ request('search') }}"
                        class="form-control"
                        placeholder="Cari nama teknisi..."
                    >
                </div>
                <select name="filterDivisi" class="form-select shadow-sm">
                    <option value="">Semua Divisi</option>
                    @foreach($divisiList as $divisi)
                        <option value="{{ $divisi->id_divisi }}" @selected(request('filterDivisi') == $divisi->id_divisi)>
                            {{ $divisi->nama_divisi }}
                        </option>
                    @endforeach
                </select>
                <button type="submit" class="btn btn-outline-danger shadow-sm">Filter</button>
            </form>
        @endif
    </div>

    {{-- Table Teknisi --}}
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
                                <a href="{{ route('teknisi.show', $item->id_teknisi) }}" class="btn btn-info btn-sm" title="Detail">
                                    <i class="bi bi-eye"></i>
                                </a>
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
                    <tr><td colspan="5" class="text-center text-muted py-3">Tidak ada data</td></tr>
                @endforelse
            </tbody>
        </table>
    </div>

    {{-- Pagination --}}
    <div class="mt-3 d-flex justify-content-between align-items-center">
        <a href="{{ $teknisi->previousPageUrl() }}" class="btn btn-pagination btn-sm @if($teknisi->onFirstPage()) disabled @endif">&larr; Prev</a>
        <span class="text-muted small">
            Halaman {{ $teknisi->currentPage() }} dari {{ $teknisi->lastPage() }}
        </span>
        <a href="{{ $teknisi->nextPageUrl() }}" class="btn btn-pagination btn-sm @if(!$teknisi->hasMorePages()) disabled @endif">Next &rarr;</a>
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
                        <label class="form-label">Divisi</label>
                        <select name="id_divisi" class="form-select shadow-sm" required>
                            <option value="">-- Pilih Divisi --</option>
                            @foreach($divisiList as $divisi)
                                <option value="{{ $divisi->id_divisi }}" @selected(old('id_divisi') == $divisi->id_divisi)>{{ $divisi->nama_divisi }}</option>
                            @endforeach
                        </select>
                        @error('id_divisi') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nama Teknisi</label>
                        <input type="text" name="nama_teknisi" class="form-control shadow-sm" value="{{ old('nama_teknisi') }}" required>
                        @error('nama_teknisi') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">NIP</label>
                        <input type="text" name="nip" class="form-control shadow-sm" value="{{ old('nip') }}" required>
                        @error('nip') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nomor Telepon</label>
                        <input type="text" name="notlp_teknisi" class="form-control shadow-sm" value="{{ old('notlp_teknisi') }}" required>
                        @error('notlp_teknisi') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Alamat</label>
                        <textarea name="alamat_teknisi" class="form-control shadow-sm" required>{{ old('alamat_teknisi') }}</textarea>
                        @error('alamat_teknisi') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control shadow-sm" value="{{ old('email') }}" required>
                        @error('email') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div>
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-control shadow-sm" required>
                        @error('password') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="submit" class="btn btn-success"><i class="bi bi-save me-1"></i> Simpan</button>
                </div>
            </form>
        </div>
    </div>

    {{-- Modal Edit --}}
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
                    <input type="hidden" name="id_teknisi" id="edit_id_teknisi">
                    <div class="mb-3">
                        <label class="form-label">Nama Teknisi</label>
                        <input type="text" name="nama_teknisi" id="edit_nama_teknisi" class="form-control shadow-sm" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">NIP</label>
                        <input type="text" name="nip" id="edit_nip" class="form-control shadow-sm" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nomor Telepon</label>
                        <input type="text" name="notlp_teknisi" id="edit_notlp_teknisi" class="form-control shadow-sm" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Alamat Teknisi</label>
                        <textarea name="alamat_teknisi" id="edit_alamat_teknisi" class="form-control shadow-sm" required></textarea>
                    </div>
                    <div>
                        <label class="form-label">Divisi</label>
                        <select name="id_divisi" id="edit_id_divisi" class="form-select shadow-sm" required>
                            <option value="">-- Pilih Divisi --</option>
                            @foreach($divisiList as $divisi)
                                <option value="{{ $divisi->id_divisi }}">{{ $divisi->nama_divisi }}</option>
                            @endforeach
                        </select>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="submit" class="btn btn-warning text-dark"><i class="bi bi-save me-1"></i> Update</button>
                </div>
            </form>
        </div>
    </div>

    {{-- Modal Hapus --}}
    <div class="modal fade" id="hapusModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <form method="POST" id="hapusForm" class="modal-content shadow-lg border-0 rounded-3">
                @csrf
                @method('DELETE')
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title"><i class="bi bi-exclamation-triangle me-2"></i>Konfirmasi Hapus</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <p class="mb-4">Apakah Anda yakin ingin menghapus data <strong id="hapusNamaTeknisi"></strong>?</p>
                    <button type="submit" class="btn btn-danger me-2"><i class="bi bi-trash3 me-1"></i> Hapus</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                </div>
            </form>
        </div>
    </div>

    {{-- Bootstrap Icons --}}
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    {{-- Script untuk modal edit dan hapus agar data bisa diisi --}}
    <script>
        const editModal = document.getElementById('editModal')
        editModal.addEventListener('show.bs.modal', event => {
            const button = event.relatedTarget
            const id = button.getAttribute('data-id')
            const nama = button.getAttribute('data-nama')
            const nip = button.getAttribute('data-nip')
            const notlp = button.getAttribute('data-notlp')
            const alamat = button.getAttribute('data-alamat')
            const divisi = button.getAttribute('data-divisi')

            const form = document.getElementById('editForm')
            form.action = `/teknisi/${id}`

            document.getElementById('edit_id_teknisi').value = id
            document.getElementById('edit_nama_teknisi').value = nama
            document.getElementById('edit_nip').value = nip
            document.getElementById('edit_notlp_teknisi').value = notlp
            document.getElementById('edit_alamat_teknisi').value = alamat
            document.getElementById('edit_id_divisi').value = divisi
        })

        const hapusModal = document.getElementById('hapusModal')
        hapusModal.addEventListener('show.bs.modal', event => {
            const button = event.relatedTarget
            const id = button.getAttribute('data-id')
            const nama = button.getAttribute('data-nama')

            const form = document.getElementById('hapusForm')
            form.action = `/teknisi/${id}`

            document.getElementById('hapusNamaTeknisi').textContent = nama
        })
    </script>
</div>
