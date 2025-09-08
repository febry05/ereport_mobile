<div>
    {{-- Alert Sukses --}}
    @if (session()->has('success'))
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> {{ session('success') }}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    @endif

    {{-- Header & Search --}}
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
        <button class="btn shadow-sm custom-btn" data-bs-toggle="modal" data-bs-target="#addModal" wire:click="resetForm">
            <i class="bi bi-plus-circle me-1"></i> Tambah Inventory
        </button>
        <div class="col-md-4 mt-2 mt-md-0">
            <div class="input-group shadow-sm">
                <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                <input type="text" id="search" class="form-control" placeholder="Cari nama inventory..."
                       wire:model.debounce.1s="search">
            </div>
        </div>
    </div>

    {{-- Table --}}
    <div class="table-responsive shadow-sm rounded">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-success">
                <tr>
                    <th style="width:5%">No</th>
                    <th>Nama Inventory</th>
                    <th style="width:15%">Jumlah</th>
                    <th style="width:20%" class="text-center">Aksi</th>
                </tr>
            </thead>
            <tbody>
                @forelse ($inventories as $index => $item)
                    <tr>
                        <td>{{ $inventories->firstItem() + $index }}</td>
                        <td class="fw-semibold">{{ $item->nama_inventory }}</td>
                        <td><span class="badge bg-primary px-3 py-2">{{ $item->jumlah }}</span></td>
                        <td class="text-center">
                            <div class="btn-group">
                                <button wire:click="edit({{ $item->id_inventory }})" 
                                        class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editModal">
                                    <i class="bi bi-pencil-square"></i>
                                </button>
                                <button class="btn btn-danger btn-sm" data-bs-toggle="modal" 
                                        data-bs-target="#hapusModal" wire:click="confirmDelete({{ $item->id_inventory }})">
                                    <i class="bi bi-trash3"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                @empty
                    <tr><td colspan="4" class="text-center text-muted py-3">Tidak ada data</td></tr>
                @endforelse
            </tbody>
        </table>
    </div>

    {{-- Pagination --}}
    <div class="mt-3 d-flex justify-content-between align-items-center">
        <button wire:click="previousPageCustom" class="btn btn-pagination btn-sm" @if($inventories->onFirstPage()) disabled @endif>
            &larr; Prev
        </button>
        <span class="text-muted small">
            Halaman {{ $inventories->currentPage() }} dari {{ $inventories->lastPage() }}
        </span>
        <button wire:click="nextPageCustom" class="btn btn-pagination btn-sm" @if(!$inventories->hasMorePages()) disabled @endif>
            Next &rarr;
        </button>
    </div>

    {{-- Modal Tambah --}}
    <div class="modal fade" id="addModal" tabindex="-1" wire:ignore.self>
        <div class="modal-dialog modal-dialog-centered">
            <form wire:submit.prevent="store" class="modal-content shadow-lg border-0 rounded-3">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title"><i class="bi bi-plus-circle me-2"></i>Tambah Inventory</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Nama Inventory</label>
                        <input type="text" wire:model.defer="nama_inventory" class="form-control shadow-sm">
                        @error('nama_inventory') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div>
                        <label class="form-label">Jumlah</label>
                        <input type="number" wire:model.defer="jumlah" class="form-control shadow-sm">
                        @error('jumlah') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button class="btn btn-success"><i class="bi bi-save me-1"></i> Simpan</button>
                </div>
            </form>
        </div>
    </div>

    {{-- Modal Edit --}}
    <div class="modal fade" id="editModal" tabindex="-1" wire:ignore.self>
        <div class="modal-dialog modal-dialog-centered">
            <form wire:submit.prevent="update" class="modal-content shadow-lg border-0 rounded-3">
                <div class="modal-header bg-warning">
                    <h5 class="modal-title text-dark"><i class="bi bi-pencil-square me-2"></i>Edit Inventory</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" wire:click="resetForm"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Nama Inventory</label>
                        <input type="text" wire:model.defer="nama_inventory" class="form-control shadow-sm">
                        @error('nama_inventory') <small class="text-danger">{{ $message }}</small> @enderror
                    </div>
                    <div>
                        <label class="form-label">Jumlah</label>
                        <input type="number" wire:model.defer="jumlah" class="form-control shadow-sm">
                        @error('jumlah') <small class="text-danger">{{ $message }}</small> @enderror
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

    {{-- Script Close Modal --}}
    <script>
        window.addEventListener('close-modal', () => {
            ['addModal', 'editModal', 'hapusModal'].forEach(id => {
                const modal = bootstrap.Modal.getInstance(document.getElementById(id));
                if (modal) modal.hide();
            });
        });
    </script>

    {{-- Bootstrap Icons --}}
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</div>
