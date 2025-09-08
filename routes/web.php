<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Web\LoginController;
use App\Http\Controllers\Web\InventoryWebController;
use App\Http\Controllers\Web\TeknisiWebController;
use App\Http\Controllers\Web\KlienWebController;
use App\Http\Controllers\Web\PicWebController;
use App\Http\Controllers\Web\KerusakanWebController;
use App\Http\Controllers\Web\FasilitasWebController;
use App\Livewire\FasilitasComponent;
use App\Livewire\KerusakanComponent;
use App\Livewire\KlienComponent;
use App\Livewire\InventoryComponent;


Route::get('/', function () {
    if (Auth::guard('web')->check()) {
        return redirect('/admin/dashboard');
    }
    return view('welcome');
});

Route::get('/admin/dashboard', function () {
    return view('admin.dashboard');
})->middleware('auth')->name('admin.dashboard');

// Login
Route::post('/login', [LoginController::class, 'login'])->name('login');

// Logout
Route::post('/logout', [LoginController::class, 'logout'])->name('logout');

Route::middleware('auth')->group(function () {
    Route::get('/inventory', [InventoryWebController::class, 'index'])->name('inventory.index');
    Route::post('/inventory', [InventoryComponent::class, 'store'])->name('inventory.store');
    Route::delete('/inventory/{id_inventory}', [InventoryComponent::class, 'destroy'])->name('inventory.destroy');
    Route::resource('teknisi', TeknisiWebController::class);
    Route::resource('pic', PicWebController::class);
    Route::resource('klien', KlienWebController::class);
    Route::get('/kerusakan', [KerusakanWebController::class, 'index'])->name('kerusakan.index');
    Route::delete('/kerusakan/{id_kerusakan}', [KerusakanComponent::class, 'destroy'])->name('kerusakan.destroy');
});