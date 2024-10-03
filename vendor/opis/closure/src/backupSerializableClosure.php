<?php

namespace Opis\Closure;

use Closure;

class SerializableClosure implements \Serializable
{
    protected $closure;

    public function __construct(Closure $closure)
    {
        $this->closure = $closure;
    }

    public function __serialize(): array
    {
        return [
            'closure' => $this->closureToString($this->closure),
        ];
    }

    public function __unserialize(array $data): void
    {
        $this->closure = $this->stringToClosure($data['closure']);
    }

    public function serialize(): string
    {
        return serialize($this->__serialize());
    }

    public function unserialize($data): void
    {
        $this->__unserialize(unserialize($data));
    }

    public function getClosure(): Closure
    {
        return $this->closure;
    }

    protected function closureToString(Closure $closure): string
    {
        // Logika untuk mengubah closure menjadi string
        return ''; // Ganti dengan implementasi yang sesuai
    }

    protected function stringToClosure(string $closureString): Closure
    {
        // Logika untuk mengubah string kembali menjadi closure
        return function() {}; // Ganti dengan implementasi yang sesuai
    }
}
