<template>
  <div class="border p-4 mb-3 rounded shadow" :data-status="generus.status">
    <div class="flex items-center justify-between mb-2">
      <p class="font-semibold">
        {{ generus.nama_lengkap }}
        <span class="text-gray-500">({{ generus.nama_panggilan }})</span>
      </p>
      <button
        v-if="generus.status"
        @click="$emit('cancel-status', generus.id)"
        class="text-red-600 font-bold"
      >
        ❌ Batalkan
      </button>
    </div>
    <div class="flex flex-wrap gap-2">
      <label
        v-for="option in statusOptions"
        :key="option"
        class="flex items-center gap-1"
      >
        <input
          type="radio"
          :name="'status-' + generus.id"
          :value="option"
          v-model="generus.status"
          @change="$emit('update-status', generus.id, option)"
        />
        {{ option }}
        <button
          v-if="generus.status === option"
          @click="
            $emit('edit-keterangan', generus.id, option, generus.keterangan)
          "
          class="ml-1 text-sm"
        >
          ✏️
        </button>
      </label>
    </div>
    <div v-if="generus.keterangan" class="mt-1 text-sm text-blue-600">
      📝 {{ generus.keterangan }}
    </div>
  </div>
</template>

<script>
export default {
  props: ["generus"],
  data() {
    return {
      statusOptions: ["Hadir", "Izin", "Sakit", "Alpa", "Terlambat"],
    };
  },
};
</script>
