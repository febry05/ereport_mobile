<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('kerusakan', function (Blueprint $table) {
            $table->id('id_kerusakan');
            $table->unsignedBigInteger('user_id')->nullable();
            $table->foreign('user_id')->references('id')->on('users')->onDelete('set null');
            $table->unsignedBigInteger('id_pic')->nullable();
            $table->foreign('id_pic')->references('id_pic')->on('pic')->onDelete('set null');
            $table->unsignedBigInteger('id_inventory')->nullable();
            $table->foreign('id_inventory')->references('id_inventory')->on('inventory')->onDelete('set null');
            $table->text('fasilitas');
            $table->date('tanggal')->nullable(); 
            $table->text('posisi');
            $table->double('lat_posisi', 10, 6);
            $table->double('lng_posisi', 10, 6);
            $table->string('deskripsi');
            $table->string('foto_kerusakan')->nullable(); 
            $table->string('foto_perbaikan')->nullable();
            $table->enum('status', [
                'pending',
                'diperbaiki',
                'selesai',
            ])->default('pending'); 
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('kerusakan');
    }
};
