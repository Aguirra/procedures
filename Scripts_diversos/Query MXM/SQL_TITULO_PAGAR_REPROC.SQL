S E L E C T   e s m o v c a d . n o t a ,  
               e s m o v c a d . d o c u m e n t o ,  
               e s m o v c a d . d a t a _ e m i s s ,  
               e s m o v c a d . c o d _ a u x ,  
               e s m o v c a d . c o d _ p a g ,  
               e s m o v c a d . c o d _ f o r ,  
               e s m o v c a d . s e t _ e s t ,  
               e s m o v c a d . c o d _ u n i ,  
               e s m o v c a d . d a t a _ m o v ,  
               f a p r d c a d . t i p o _ p r d ,  
               t b _ i n t e g r a c a o _ m x m . t p _ t i p o ,  
               e s m o v c a d . d a t a _ d i g ,  
               S u m ( e s m o v i t e . v a l o r _ t o t )   A S   V A L O R  
 F R O M       e s m o v c a d  
               I N N E R   J O I N   e s m o v i t e  
                               O N   (   e s m o v c a d . t i p o _ d o c u m e n t o   =   e s m o v i t e . t i p o _ d o c u m e n t o  
                                         A N D   e s m o v c a d . d o c u m e n t o   =   e s m o v i t e . d o c u m e n t o  
                                         A N D   e s m o v c a d . n o t a   =   e s m o v i t e . n o t a   )  
               I N N E R   J O I N   f a p r d c a d  
                               O N   (   f a p r d c a d . c o d i g o   =   e s m o v i t e . c o d _ p r d   )  
               L E F T   J O I N   t b _ i n t e g r a c a o _ m x m  
                             O N   (   t b _ i n t e g r a c a o _ m x m . c o _ c h a v e 1   =   e s m o v c a d . t i p o _ d o c u m e n t o  
                                       A N D   t b _ i n t e g r a c a o _ m x m . c o _ c h a v e 2   =   e s m o v c a d . d o c u m e n t o  
                                       A N D   t b _ i n t e g r a c a o _ m x m . c o _ c h a v e 3   =   e s m o v c a d . n o t a | | ' . ' | | e s m o v c a d . n u _ s e r i e   )  
 W H E R E     e s m o v c a d . t i p o _ d o c u m e n t o   =   ' C O M '  
               A N D   (   E X I S T S   ( S E L E C T   e s p e c i e _ n o t a . c o d _ e s p e c i e  
                                           F R O M       e s p e c i e _ n o t a  
                                           W H E R E     e s m o v c a d . f k _ c o d _ e s p e c i e   =   e s p e c i e _ n o t a . c o d _ e s p e c i e  
                                                         A N D   (   e s p e c i e _ n o t a . f k _ e s n f c g   =   ' '  
                                                                       O R   e s p e c i e _ n o t a . f k _ e s n f c g   I S   N U L L   ) )  
                             O R   (   e s m o v c a d . f k _ c o d _ e s p e c i e   I S   N U L L  
                                         O R   e s m o v c a d . f k _ c o d _ e s p e c i e   =   ' '   )   )  
               A N D   t b _ i n t e g r a c a o _ m x m . p k _ i n t m x m   I S   N O T   N U L L  
               A N D   t b _ i n t e g r a c a o _ m x m . s t _ n o t a   =   ' P '  
               A N D   t b _ i n t e g r a c a o _ m x m . s n _ a v u l s o   =   ' N '  
               A N D   E X I S T S   ( S E L E C T   f a s e t c a d . c o d _ s e t  
                                       F R O M       f a s e t c a d  
                                       W H E R E     e s m o v c a d . s e t _ e s t   =   f a s e t c a d . c o d _ s e t  
                                                     A N D   E X I S T S   ( S E L E C T   f a c e l c a d . c o d _ c e l  
                                                                             F R O M       f a c e l c a d  
                                                                             W H E R E     f a s e t c a d . c o d _ c e l   =   f a c e l c a d . c o d _ c e l  
                                                                                           A N D   f a c e l c a d . c o d _ u n i d a d e   =   ' 0 0 0 1 ' ) )  
 G R O U P     B Y   e s m o v c a d . n o t a ,  
                     e s m o v c a d . d o c u m e n t o ,  
                     e s m o v c a d . d a t a _ e m i s s ,  
                     e s m o v c a d . c o d _ a u x ,  
                     e s m o v c a d . c o d _ p a g ,  
                     e s m o v c a d . c o d _ f o r ,  
                     e s m o v c a d . s e t _ e s t ,  
                     e s m o v c a d . c o d _ u n i ,  
                     e s m o v c a d . d a t a _ m o v ,  
                     f a p r d c a d . t i p o _ p r d ,  
                     t b _ i n t e g r a c a o _ m x m . t p _ t i p o ,  
                     e s m o v c a d . d a t a _ d i g  
 O R D E R     B Y   e s m o v c a d . c o d _ f o r ,  
                     n o t a    
  
 