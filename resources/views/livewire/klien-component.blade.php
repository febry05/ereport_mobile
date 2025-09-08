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
        <button class="btn shadow-sm custom-btn" data-bs-toggle="modal" data-bs-target="#addModal" wire:click="resetForm">
            <i class="bi bi-plus-circle me-1"></i> Tambah Klien
        </button>

        @if ($klien->currentPage() == 1)
            <div class="d-flex gap-2 mt-2 mt-md-0">
                <div class="input-group shadow-sm">
                    <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                    <input type="text" id="search" class="form-control" placeholder="Cari nama klien..." wire:model.debounce.500ms="search">
                </div>
                <div class="dropdown">
                <button class="btn btn-outline-danger shadow-sm dropdown-toggle" type="button" data-bs-toggle="dropdown">
                    {{ $divisiList->firstWhere('id_divisi', $filterDivisi)->nama_divisi ?? 'Semua Divisi' }}
                </button>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" wire:click="$set('filterDivisi', '')">Semua Divisi</a></li>
                    @foreach($divisiList as $divisi)
                    <li>
                        <a class="dropdown-item" wire:click="$set('filterDivisi', {{ $divisi->id_divisi }})">
                        {{ $divisi->nama_divisi }}
                        </a>
                    </li>
                    @endforeach
                </ul>
                </div>
            </div>
        @endif
    </div>


    {{-- Table Klien --}}
    <div wire:poll.visible.5s class="table-responsive shadow-sm rounded">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-success">
                <tr>
                    <th style="width:5%">No</th>
                    <th>Nama Klien</th>
                    <th>NIP</th>
                    <th>Divisi</th>
                    <th style="width:20%" class="text-center">Aksi</th>
                </tr>
            </thead>
            <tbody>
                @forelse ($klien as $index => $item)
                    <tr>
                        <td>{{ $klien->firstItem() + $index }}</td>
                        <td class="fw-semibold">{{ $item->nama_klien }}</td>
                        <td>{{ $item->nip }}</td>
                        <td>{{ $item->divisi->nama_divisi ?? '-' }}</td>
                        <td class="text-center">
                            <div class="btn-group">
                                <button wire:click="showDetail({{ $item->id_klien }})" class="btn btn-info btn-sm">
                                    <i class="bi bi-eye"></i>
                                </button>
                                <button wire:click="edit({{ $item->id_klien }})" class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editModal">
                                    <i class="bi bi-pencil-square"></i>
                                </button>
                                <button class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#hapusModal" wire:click="confirmDelete({{ $item->id_klien }})">
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
         <button wire:click="previousPageCustom" class="btn btn-pagination btn-sm" @if($klien->onFirstPage()) disabled @endif>
            &larr; Prev
        </button>
        <span class="text-muted small">
            Halaman {{ $klien->currentPage() }} dari {{ $klien->lastPage() }}
        </span>
        <button wire:click="nextPageCustom" class="btn btn-pagination btn-sm" @if(!$klien->hasMorePages()) disabled @endif>
            Next &rarr;
        </button>
    </div>

    {{-- Modal Tambah Klien --}}
    <div class="modal fade" id="addModal" tabindex="-1" wire:ignore.self>
        <div class="modal-dialog modal-dialog-centered">
            <form wire:submit.prevent="store" class="modal-content shadow-lg border-0 rounded-3">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title"><i class="bi bi-plus-circle me-2"></i>Tambah Klien</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Divisi</label>
                        <select wire:model.defer="id_divisi" class="form-select shadow-sm">
                            <option value="">-- Pilih Divisi --</option>
                            @foreach($divisiList as $divisi)
                                <option value="{{ $divisi->id_divisi }}">{{ $divisi->nama_divisi }}</option>
                            @endforeach
                        </select>
                        @error('id_divisi') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nama Klien</label>
                        <input type="text" wire:model.defer="nama_klien" class="form-control shadow-sm">
                        @error('nama_klien') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">NIP</label>
                        <input type="text" wire:model.defer="nip" class="form-control shadow-sm">
                        @error('nip') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nomor Telepon</label>
                        <input type="text" wire:model.defer="notlp_klien" class="form-control shadow-sm">
                        @error('notlp_klien') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Alamat</label>
                        <textarea wire:model.defer="alamat_klien" class="form-control shadow-sm"></textarea>
                        @error('alamat_klien') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" wire:model.defer="email" class="form-control shadow-sm">
                        @error('email') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div>
                        <label class="form-label">Password</label>
                        <input type="password" wire:model.defer="password" class="form-control shadow-sm">
                        @error('password') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button class="btn btn-success"><i class="bi bi-save me-1"></i> Simpan</button>
                </div>
            </form>
        </div>
    </div>

    {{-- Modal Detail --}}
    <div class="modal fade" id="detailModal" tabindex="-1" wire:ignore.self>
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg border-0 rounded-3">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title"><i class="bi bi-info-circle me-2"></i>Detail Klien</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    @if ($selectedKlien)
                        <p><strong>Nama:</strong> {{ $selectedKlien->nama_klien }}</p>
                        <p><strong>NIP:</strong> {{ $selectedKlien->nip }}</p>
                        <p><strong>Divisi:</strong> {{ $selectedKlien->divisi->nama_divisi ?? '-' }}</p>
                        <p><strong>No. Telepon:</strong> {{ $selectedKlien->notlp_klien ?? '-' }}</p>
                        <p><strong>Alamat:</strong> {{ $selectedKlien->alamat_klien ?? '-' }}</p>
                        <p><strong>Email:</strong> {{ $selectedKlien->user->email ?? '-' }}</p>
                    @else
                        <p class="text-muted">Memuat data...</p>
                    @endif
                </div>
                <div class="modal-footer border-0">
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
                </div>
            </div>
        </div>
    </div>

    {{-- Modal Edit --}}
    <div class="modal fade" id="editModal" tabindex="-1" wire:ignore.self>
        <div class="modal-dialog modal-dialog-centered">
            <form wire:submit.prevent="update" class="modal-content shadow-lg border-0 rounded-3">
                <div class="modal-header bg-warning">
                    <h5 class="modal-title text-dark"><i class="bi bi-pencil-square me-2"></i>Edit Klien</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" wire:click="resetForm"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Nama Klien</label>
                        <input type="text" wire:model.defer="nama_klien" class="form-control shadow-sm">
                        @error('nama_klien') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">NIP</label>
                        <input type="number" wire:model.defer="nip" class="form-control shadow-sm">
                        @error('nip') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nomor Telepon</label>
                        <input type="number" wire:model.defer="notlp_klien" class="form-control shadow-sm">
                        @error('notlp_klien') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Alamat Klien</label>
                        <input type="text" wire:model.defer="alamat_klien" class="form-control shadow-sm">
                        @error('alamat_klien') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div>
                        <label class="form-label">Divisi</label>
                        <select wire:model.defer="id_divisi" class="form-select shadow-sm">
                            <option value="">-- Pilih Divisi --</option>
                            @foreach($divisiList as $divisi)
                                <option value="{{ $divisi->id_divisi }}">{{ $divisi->nama_divisi }}</option>
                            @endforeach
                        </select>
                        @error('id_divisi') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button class="btn btn-warning text-dark"><i class="bi bi-save me-1"></i> Update</button>
                </div>
            </form>
        </div>
    </div>

    {{-- Modal Hapus --}}
    <div class="modal fade" id="hapusModal" tabindex="-1" wire:ignore.self>
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg border-0 rounded-3">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title"><i class="bi bi-exclamation-triangle me-2"></i>Konfirmasi Hapus</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" wire:click="resetForm"></button>
                </div>
                <div class="modal-body text-center">
                    <p class="mb-4">Apakah Anda yakin ingin menghapus data ini?</p>
                    <button wire:click="destroy" class="btn btn-danger me-2"><i class="bi bi-trash3 me-1"></i> Hapus</button>
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                </div>
            </div> 
        </div>
    </div>

    {{-- Script Modal --}}
    <script>
        window.addEventListener('close-modal', () => {
            ['addModal', 'editModal', 'hapusModal'].forEach(id => {
                const modal = bootstrap.Modal.getInstance(document.getElementById(id));
                if (modal) modal.hide();
            });
        });

        Livewire.on('show-detail-modal', () => {
            const detailModal = new bootstrap.Modal(document.getElementById('detailModal'));
            detailModal.show();
        });
    </script>

    {{-- Bootstrap Icons --}}
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</div>
