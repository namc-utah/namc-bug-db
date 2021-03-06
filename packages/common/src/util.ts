import { camelCase, snakeCase } from 'change-case'
import { StrObj } from './types'

/**
 * transform an object's keys from one case to another
 */
export const camel2snake = (inobj: StrObj): StrObj =>
    Object.keys(inobj).reduce((acc, key) => ({ ...acc, [snakeCase(key)]: inobj[key] }), {})

export const snake2camel = (inobj: StrObj): StrObj =>
    Object.keys(inobj).reduce((acc, key) => ({ ...acc, [camelCase(key)]: inobj[key] }), {})
