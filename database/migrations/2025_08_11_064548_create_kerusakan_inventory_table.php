<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('kerusakan_inventory', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('id_kerusakan');
            $table->unsignedBigInteger('id_inventory');
            $table->integer('jumlah');

            $table->foreign('id_kerusakan')->references('id_kerusakan')->on('kerusakan')->onDelete('cascade');
            $table->foreign('id_inventory')->references('id_inventory')->on('inventory')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('kerusakan_inventory');
    }
};
