S E L E C T   f a n o t c a d . n o t a _ f i s c a l ,  
               f a n o t c a d . s e r i e ,  
               f a n o t c a d . d a t a _ e m i s s ,  
               f a n o t c a d . v a l o r _ t o t ,  
               f a f a t p a g . c o d _ a d m i n _ c a r t c r e d ,  
               f a n o t c a d . c g c _ d e s t                   I D _ P A C I E N T E ,  
               f a n o t c a d . c o d _ u n i ,  
               f a n o t c a d . c o d _ p a c ,  
               f a n o t c a d . e n d _ d e s t ,  
               f a n o t c a d . b a i _ d e s t ,  
               f a n o t c a d . c i d _ d e s t ,  
               f a n o t c a d . e s t _ d e s t ,  
               f a n o t c a d . c e p _ d e s t ,  
               f a n o t c a d . f o n e _ d e s t ,  
               f a n o t c a d . i n s c _ e s t _ d e s t ,  
               f a n o t c a d . n o m e _ d e s t ,  
               f a n o t c a d . c g c _ d e s t ,  
               f a n o t c a d . c o m p l _ d e s t ,  
               f a n o t c a d . t i p o _ n o t a ,  
               f a n o t c a d . i n d _ d e s t ,  
               f a n o t c a d . c o d _ c o n ,  
               f a n o t c a d . c o d i f i c a c a o ,  
               t b _ i n t e g r a c a o _ m x m . t p _ t i p o   A S   t i p o _ i n t e g r a c a o  
 F R O M       f a n o t c a d  
               I N N E R   J O I N   f a f a t c a d  
                               O N   (   f a f a t c a d . n o t a _ f i s c a l   =   f a n o t c a d . n o t a _ f i s c a l  
                                         A N D   f a f a t c a d . c o d _ p a c   =   f a n o t c a d . c o d _ p a c   )  
               L E F T   J O I N   f a f a t p a g  
                             O N   (   f a f a t c a d . f a t u r a   =   f a f a t p a g . f a t u r a   )  
               L E F T   J O I N   t b _ i n t e g r a c a o _ m x m  
                             O N   (   t b _ i n t e g r a c a o _ m x m . c o _ c h a v e 1   =   f a n o t c a d . n o t a _ f i s c a l  
                                       A N D   t b _ i n t e g r a c a o _ m x m . c o _ c h a v e 2   =   f a n o t c a d . s e r i e  
                                       A N D   t b _ i n t e g r a c a o _ m x m . c o _ c h a v e 3   =   f a n o t c a d . c o d _ u n i   )  
 W H E R E     f a n o t c a d . c o d _ p a c   I S   N O T   N U L L  
               A N D   f a n o t c a d . c o d _ p a c   < >   ' '  
               A N D   f a n o t c a d . c a n c e l a d a   < >   ' S '  
               A N D   t b _ i n t e g r a c a o _ m x m . p k _ i n t m x m   I S   N O T   N U L L  
               A N D   t b _ i n t e g r a c a o _ m x m . s t _ n o t a   =   ' P '  
               A N D   t b _ i n t e g r a c a o _ m x m . s n _ a v u l s o   =   ' N '  
               A N D   f a n o t c a d . c o d _ u n i   =   ' 0 0 0 1 '  
 U N I O N  
 S E L E C T   f a n o t c a d . n o t a _ f i s c a l ,  
               f a n o t c a d . s e r i e ,  
               f a n o t c a d . d a t a _ e m i s s ,  
               f a n o t c a d . v a l o r _ t o t ,  
               f a f a t p a g . c o d _ a d m i n _ c a r t c r e d ,  
               f a n o t c a d . n o m e _ d e s t                 I D _ P A C I E N T E ,  
               f a n o t c a d . c o d _ u n i ,  
               f a n o t c a d . c o d _ p a c ,  
               f a n o t c a d . e n d _ d e s t ,  
               f a n o t c a d . b a i _ d e s t ,  
               f a n o t c a d . c i d _ d e s t ,  
               f a n o t c a d . e s t _ d e s t ,  
               f a n o t c a d . c e p _ d e s t ,  
               f a n o t c a d . f o n e _ d e s t ,  
               f a n o t c a d . i n s c _ e s t _ d e s t ,  
               f a n o t c a d . n o m e _ d e s t ,  
               f a n o t c a d . c g c _ d e s t ,  
               f a n o t c a d . c o m p l _ d e s t ,  
               f a n o t c a d . t i p o _ n o t a ,  
               f a n o t c a d . i n d _ d e s t ,  
               f a n o t c a d . c o d _ c o n ,  
               f a n o t c a d . c o d i f i c a c a o ,  
               t b _ i n t e g r a c a o _ m x m . t p _ t i p o   A S   t i p o _ i n t e g r a c a o  
 F R O M       f a n o t c a d  
               I N N E R   J O I N   f a f a t c a d  
                               O N   (   f a f a t c a d . n o t a _ f i s c a l   =   f a n o t c a d . n o t a _ f i s c a l   )  
               L E F T   J O I N   f a f a t p a g  
                             O N   (   f a f a t c a d . f a t u r a   =   f a f a t p a g . f a t u r a   )  
               L E F T   J O I N   t b _ i n t e g r a c a o _ m x m  
                             O N   (   t b _ i n t e g r a c a o _ m x m . c o _ c h a v e 1   =   f a n o t c a d . n o t a _ f i s c a l  
                                       A N D   t b _ i n t e g r a c a o _ m x m . c o _ c h a v e 2   =   f a n o t c a d . s e r i e  
                                       A N D   t b _ i n t e g r a c a o _ m x m . c o _ c h a v e 3   =   f a n o t c a d . c o d _ u n i   )  
 W H E R E     (   f a n o t c a d . c o d _ p a c   I S   N U L L  
                     O R   f a n o t c a d . c o d _ p a c   =   ' '   )  
               A N D   f a n o t c a d . c a n c e l a d a   < >   ' S '  
               A N D   t b _ i n t e g r a c a o _ m x m . p k _ i n t m x m   I S   N O T   N U L L  
               A N D   t b _ i n t e g r a c a o _ m x m . s t _ n o t a   =   ' P '  
               A N D   t b _ i n t e g r a c a o _ m x m . s n _ a v u l s o   =   ' N '  
               A N D   f a n o t c a d . c o d _ u n i   =   ' 0 0 0 1 '  
 O R D E R     B Y   f a n o t c a d . n o t a _ f i s c a l ,  
                     f a n o t c a d . s e r i e ,  
                     f a f a t p a g . c o d _ a d m i n _ c a r t c r e d   D E S C    
  
 