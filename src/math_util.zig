const std = @import("std");
const zignal_point_module = @import("zignal/point.zig");

pub fn clamp(min: i8, value: i8) i8 {
    if (value < min) {
        return min;
    }
    return value;
}

// Linear interpolation between two floats.
// `t` is used to interpolate between `from` and `to`.
pub fn lerp(comptime T: type, from: T, to: T, t: T) T {
    return (1 - t) * from + t * to;
}

// Convert radians to degrees.
pub fn toDegrees(radians: anytype) @TypeOf(radians) {
    return radians * (180.0 / std.math.pi);
}

// Return the angle (in degrees) between two points
pub fn getAngle(
    pointA: zignal_point_module.Point2d(), 
    pointB: zignal_point_module.Point2d()
    ) zignal_point_module.Point2d() 
{
    const pointANorm = pointA.norm();
    const pointBNorm = pointB.norm();
    const dotProduct = pointANorm.scale(pointBNorm.x, pointBNorm.y);
    return toDegrees(std.math.acos(dotProduct));
}