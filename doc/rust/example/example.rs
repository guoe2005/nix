//use std::mem;
//
//// 此函数借用一个 slice
//fn analyze_slice(slice: &[i32]) {
//    println!("first element of the slice: {}", slice[0]);
//    println!("the slice has {} elements", slice.len());
//}
//
//fn main() {
//    // 定长数组（类型标记是多余的）
//    let xs: [i32; 5] = [1, 2, 3, 4, 5];
//
//    // 所有元素可以初始化成相同的值
//    let ys: [i32; 500] = [0; 500];
//
//    // 下标从 0 开始
//    println!("first element of the array: {}", xs[0]);
//    println!("second element of the array: {}", xs[1]);
//
//    // `len` 返回数组的大小
//    println!("array size: {}", xs.len());
//
//    // 数组是在栈中分配的
//    println!("array occupies {} bytes", mem::size_of_val(&xs));
//
//    // 数组可以自动被借用成为 slice
//    println!("borrow the whole array as a slice");
//    analyze_slice(&xs);
//
//    // slice 可以指向数组的一部分
//    println!("borrow a section of the array as a slice");
//    analyze_slice(&ys[1 .. 4]);
//
//    // 越界的下标会引发致命错误（panic）
//    //println!("{}", xs[5]);
//}
//
//
//
//#![allow(dead_code)]
//enum Number {
//// 拥有隐式辨别值（implicit discriminator，从 0 开始）的 enum
//    Zero, 
//    One,
//}
//enum Color{
//    Red =0xff0000
//}
//fn main () {
//    println!("Zero is {}", Number::Zero as i32);
//    println!("Zero is {:?}", Number::Zero as i32);
//    //println!("One is {:#?}", Number::One);
//
//    println!("roses are #{:06x}",Color::Red as i32);
//}




//测试实例：链表
//use List::*;
//
//enum List{
//    Cons(u32,Box<List>),
//    Nil,
//}
//
//impl List{
//    fn new() -> List{
//        Nil
//    }
//
//    fn prepend(self, elem: u32) -> List{
//        Cons(elem, Box::new(self))
//    }
//    fn len(&self) -> u32 {
//        match *self {
//            Cons(_, ref tail) => 1 + tail.len(),
//            Nil => 0
//        }
//    }
//    fn stringigy(&self) -> String {
//        match *self {
//            Cons(head, ref tail) => {
//                format!("{}, {}", head , tail.stringigy())
//            },
//            Nil => {
//                format!("Nil")
//            }
//        }
//    }
//
//}
//
//fn main() {
//    let mut list = List::new();
//
//    list = list.prepend(1);
//
//    println!("linked list has length:{}", list.len());
//    println!("{}", list.stringigy());
//}
//
//
//
//

//常量
static LANGUAGE: &'static str = "Rust";
const THRESHOLD: i32 = 10;

fn is_big(n: i32) -> bool {
    n > THRESHOLD
}

fn main() {
    let n= 16;

    println!("This is {}", LANGUAGE);
    println!("The threshold is {}", THRESHOLD);
    println!("{} is {}",n , if is_big(n) {"big"} else {"small"});

    //THRESHOLD = 5;
}


