use futures::executor::block_on;
use std::time::Duration;
use std::thread::sleep;

fn main() {
    let future = hello_world();
    block_on(future);
}

async fn hello_world() {
    loop {
        println!("hello world test!");
        delay().await
    }
}

async fn delay() {
    let ten_secs = Duration::from_secs(10);
    sleep(ten_secs);
}