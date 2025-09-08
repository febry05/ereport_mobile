<div>
    {{-- Alert Sukses --}}
    @if (session()->has('success'))
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> {{ session('success') }}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    @endif

    {{-- Header: Search/Filter --}}
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
        @if ($kerusakan->currentPage() == 1)
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
                <div class="input-group shadow-sm">
                    <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                    <input type="text" id="search" class="form-control" placeholder="Cari nama fasilitas..." wire:model.debounce.10ms="search">
                </div>
            </div>
            <div class="d-flex gap-2 mt-2 mt-md-0">
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
                <div class="dropdown">
                    <button class="btn btn-outline-danger shadow-sm dropdown-toggle" type="button" data-bs-toggle="dropdown">
                        {{ $filterStatus ?: 'Semua Status' }}
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" wire:click="$set('filterStatus', '')">Semua Status</a></li>
                        @foreach($statusList as $status)
                        <li>
                            <a class="dropdown-item" wire:click="$set('filterStatus', '{{ $status->status }}')">
                                {{ ucfirst($status->status) }}
                            </a>
                        </li>
                        @endforeach
                    </ul>
                </div>
            </div>
        @endif
    </div>


    {{-- Table Kerusakan --}}
    <div class="table-responsive shadow-sm rounded">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-success">
                <tr>
                    <th style="width:5%">No</th>
                    <th>Fasilitas</th>
                    <th>Lokasi</th>
                    <th>Divisi</th>
                    <th>Status</th>
                    <th>Foto Kerusakan</th>
                    <th style="width:20%" class="text-center">Aksi</th>
                </tr>
            </thead>
            <tbody>
                @forelse ($kerusakan as $index => $item)
                    <tr>
                        <td>{{ $kerusakan->firstItem() + $index }}</td>
                        <td class="fw-semibold">{{ $item->fasilitas }}</td>
                        <td>{{ $item->posisi }}</td>
                        <td>{{ $item->divisi->nama_divisi ?? '-' }}</td>
                        <td>{{ $item->status }}</td>
                        <td>
                            @if($item->foto_kerusakan)
                                <img src="{{ asset('storage/' . $item->foto_kerusakan) }}" alt="Foto Kerusakan" style="max-width: 100px; max-height: 80px; object-fit: cover; border-radius: 4px;">
                            @else
                                -
                            @endif
                        </td>
                        <td class="text-center">
                            <div class="btn-group">
                                <button wire:click="showDetail({{ $item->id_kerusakan }})" class="btn btn-info btn-sm">
                                    <i class="bi bi-eye"></i>
                                </button>
                                <button wire:click="showSelesai({{ $item->id_kerusakan }})" class="btn btn-success btn-sm">
                                    <i class="bi bi-file-earmark-check"></i> 
                                </button>
                                <button class="btn btn-secondary btn-sm">
                                    <i class="bi bi-printer"></i> 
                                </button>
                                <button class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#hapusModal" wire:click="confirmDelete({{ $item->id_kerusakan }})">
                                    <i class="bi bi-trash3"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                @empty
                    <tr><td colspan="7" class="text-center text-muted py-3">Tidak ada data</td></tr>
                @endforelse
            </tbody>
        </table>
    </div>

    {{-- Pagination --}}
    <div class="mt-3 d-flex justify-content-between align-items-center">
         <button wire:click="previousPageCustom" class="btn btn-pagination btn-sm" @if($kerusakan->onFirstPage()) disabled @endif>
            &larr; Prev
        </button>
        <span class="text-muted small">
            Halaman {{ $kerusakan->currentPage() }} dari {{ $kerusakan->lastPage() }}
        </span>
        <button wire:click="nextPageCustom" class="btn btn-pagination btn-sm" @if(!$kerusakan->hasMorePages()) disabled @endif>
            Next &rarr;
        </button>
    </div>

    {{-- Modal Detail --}}
    <div class="modal fade" id="detailModal" tabindex="-1" wire:ignore.self>
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg border-0 rounded-3">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title"><i class="bi bi-info-circle me-2"></i>Detail Kerusakan</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    @if ($selectedKerusakan)
                        <p><strong>Pelapor:</strong> {{ $selectedKerusakan->user->name }}</p>
                        <p><strong>Bagian:</strong> {{ $selectedKerusakan->user->role->nama_role }}</p>
                        <p><strong>Fasilitas:</strong> {{ $selectedKerusakan->fasilitas }}</p>
                        @if ($selectedKerusakan)
                            <p><strong>Posisi:</strong> {{ $selectedKerusakan->posisi }}</p>
                            <iframe 
                                width="100%" 
                                height="150" 
                                style="border:0; border-radius:8px;" 
                                loading="lazy" 
                                allowfullscreen
                                src="https://www.google.com/maps?q={{ $selectedKerusakan->lat_posisi }},{{ $selectedKerusakan->lng_posisi }}&hl=id&z=16&output=embed">
                            </iframe>
                        @endif
                        <p><strong>Tanggal:</strong> {{ $selectedKerusakan->tanggal}}</p>
                        <p><strong>Deskripsi:</strong> {{ $selectedKerusakan->deskripsi}}</p>
                        <p><strong>Foto Kerusakan:</strong></p>
                            @if($selectedKerusakan->foto_kerusakan)
                                <img src="{{ asset('storage/' . $selectedKerusakan->foto_kerusakan) }}" alt="Foto Kerusakan" style="max-width: 300px; max-height: 200px; object-fit: contain; border-radius: 6px;">
                            @else
                                <p class="text-muted">Tidak ada foto.</p>
                            @endif
                        <p><strong>Divisi:</strong> {{ $selectedKerusakan->divisi->nama_divisi}}</p>
                        <p><strong>Status:</strong> {{ $selectedKerusakan->status}}</p>
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

    <div class="modal fade" id="selesaiModal" tabindex="-1" wire:ignore.self>
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg border-0 rounded-3">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title"><i class="bi bi-info-circle me-2"></i>Bukti Penyelesaian</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    @if ($selectedKerusakan)
                        <p><strong>Pelapor:</strong> {{ $selectedKerusakan->user->name }}</p>
                        <p><strong>Penanggunga Jawab:</strong> {{ $selectedKerusakan->pic->nama_pic  ?? '-' }}</p>
                        <p><strong>Inventory:</strong> {{ $selectedKerusakan->kerusakan_inventory->inventory->nama_inventory  ?? '-'  }}</p>
                        <p><strong>Jumlah:</strong> {{ $selectedKerusakan->kerusakan_inventory->jumlah  ?? '-' }}</p>
                        <p><strong>Tanggal:</strong> {{ $selectedKerusakan->tanggal_perbaikan  ?? '-' }}</p>
                        <p><strong>Foto Perbaikan:</strong></p>
                            @if($selectedKerusakan->foto_perbaikan)
                                <img src="{{ asset('storage/' . $selectedKerusakan->foto_perbaikan) }}" alt="Foto Perbaikan" style="max-width: 300px; max-height: 200px; object-fit: contain; border-radius: 6px;">
                            @else
                                <p class="text-muted">Tidak ada foto.</p>
                            @endif
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

    {{-- Modal Hapus --}}
    <div class="modal fade" id="hapusModal" tabindex="-1" wire:ignore.self>
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg border-0 rounded-3">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title"><i class="bi bi-exclamation-triangle me-2"></i>Konfirmasi Hapus</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <p class="mb-4">Apakah Anda yakin ingin menghapus data ini?</p>
                    <button wire:click="destroy" class="btn btn-danger me-2"><i class="bi bi-trash3 me-1"></i> Hapus</button>
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                </div>
            </div> 
        </div>
    </div>

    {{-- Bootstrap Icons --}}
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</div>
