use crate::context::DaoContext;

use std::cell::RefCell;

pub mod actor;

pub mod constant;

pub mod context;

pub mod env;

pub mod guard;

pub mod post;

pub mod user;

thread_local! {
    static CONTEXT: RefCell<DaoContext> = RefCell::default();
}