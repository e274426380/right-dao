use crate::context::DaoContext;

use std::cell::RefCell;

pub mod actor;

pub mod constant;

pub mod env;

pub mod context;

pub mod user;

thread_local! {
    static CONTEXT: RefCell<DaoContext> = RefCell::default();
}