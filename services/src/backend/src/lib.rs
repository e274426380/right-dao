use crate::context::DaoContext;

use std::cell::RefCell;

pub mod actor;

pub mod common;

pub mod context;

pub mod env;

pub mod post;

pub mod user;

thread_local! {
    static CONTEXT: RefCell<DaoContext> = RefCell::default();
}