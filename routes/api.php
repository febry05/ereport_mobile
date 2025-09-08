<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\TeknisiController;
use App\Http\Controllers\KlienController;
use App\Http\Controllers\PicController;
use App\Http\Controllers\KerusakanController;
use App\Http\Controllers\KerusakanInventoryController;
use Illuminate\Http\Request;
use App\Models\Role;

Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:api', 'role:teknisi')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/teknisi/profile', [TeknisiController::class, 'getProfile']);
    Route::put('/teknisi/update', [TeknisiController::class, 'updateByUserId']);
    Route::get('/teknisi/kerusakan', [KerusakanController::class, 'index']);
    Route::post('/teknisi/kerusakan', [KerusakanController::class, 'store']);
});

Route::middleware('auth:api', 'role:klien')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/klien/profile', [KlienController::class, 'getProfile']);
    Route::put('/klien/update', [KlienController::class, 'updateByUserId']);
    Route::get('/klien/kerusakan', [KerusakanController::class, 'index_klien']);
    Route::post('/klien/kerusakan', [KerusakanController::class, 'store']);
});

Route::middleware('auth:api', 'role:pic')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/pic/profile', [PicController::class, 'getProfile']);
    Route::put('/pic/update', [PicController::class, 'updateByUserId']);
    Route::post('/kerusakan/{id_kerusakan}/inventory', [KerusakanInventoryController::class, 'addInventoryToKerusakan']);
});