Function writeUInt32BE = (target, value) {
  target[0] = ((value & 0xffffffff) >> 24);
  target[1] = ((value & 0xffffffff) >> 16);
  target[2] = ((value & 0xffffffff) >> 8);
  target[3] = ((value & 0xffffffff) & 0xff);
  return target;
};
