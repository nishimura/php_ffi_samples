{-# LANGUAGE ForeignFunctionInterface #-}

#include "template_operations.h"

module HaskellPhp where

import Foreign
import Foreign.C.String
import Foreign.C.Types

data Tops = Tops { assign::FunPtr (CString -> CString -> IO CInt) }

foreign export ccall hsParse :: CString -> Ptr Tops -> IO CString
foreign import ccall "dynamic" mkFun :: FunPtr (CString -> CString -> IO CInt)
                                     -> (CString -> CString -> IO CInt)
foreign import ccall "assign_value_get" value_get :: IO CString



instance Storable Tops where
    sizeOf _ = #size CTOPS
    alignment _ = #alignment CTOPS
    peek ptr = do
      assign' <- (#peek CTOPS, assign) ptr
      return Tops { assign=assign' }
    poke ptr (Tops assign') = do
                           (#poke CTOPS, assign) ptr assign'


--
-- Function to parse some string
--
hsParse :: CString -> Ptr Tops -> IO CString
hsParse cs cops = do
  ops <- peek cops
  let f = mkFun $ assign ops
  a <- newCString "foo"
  b <- newCString "bar"
  r <-  f a b
  cstr <- value_get
  s <- peekCString cstr
  newCString $ "hsParse finish: [" ++ show r ++ "]" ++ "[" ++ s ++ "]"
