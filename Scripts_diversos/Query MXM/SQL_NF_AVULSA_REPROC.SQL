S E L E C T   f a n o t a v l . n o t a _ f i s c a l ,  
               f a n o t a v l . d a t a _ e m i s s ,  
               f a n o t a v l . v a l o r _ t o t ,  
               f a n o t a v l . c g c ,  
               f a n o t a v l . c o d _ u n i ,  
               f a n o t a v l . s e r i e ,  
               f a n o t a v l . n o m e ,  
               f a n o t a v l . c o d _ p a c ,  
               f a n o t a v l . c o d _ c o n ,  
               f a n o t a v l . e n d e r e c o   E N D _ D E S T ,  
               f a n o t a v l . b a i r r o       B A I _ D E S T ,  
               f a n o t a v l . c i d a d e       C I D _ D E S T ,  
               f a n o t a v l . c o d i f i c a c a o ,  
               f a n o t a v l . e s t a d o       E S T _ D E S T ,  
               f a n o t a v l . i n s c _ e s t   I N S C _ E S T _ D E S T ,  
               f a n o t a v l . c e p _ d e s t ,  
               t b _ i n t e g r a c a o _ m x m . t p _ t i p o  
 F R O M       f a n o t a v l  
               L E F T   J O I N   t b _ i n t e g r a c a o _ m x m  
                             O N   (   t b _ i n t e g r a c a o _ m x m . c o _ c h a v e 1   =   f a n o t a v l . n o t a _ f i s c a l  
                                       A N D   t b _ i n t e g r a c a o _ m x m . c o _ c h a v e 2   =   f a n o t a v l . s e r i e  
                                       A N D   t b _ i n t e g r a c a o _ m x m . c o _ c h a v e 3   =   f a n o t a v l . c o d _ u n i   )  
 W H E R E     f a n o t a v l . i n d _ s t a t u s   < >   ' C '  
               A N D   t b _ i n t e g r a c a o _ m x m . p k _ i n t m x m   I S   N O T   N U L L  
               A N D   t b _ i n t e g r a c a o _ m x m . s t _ n o t a   =   ' P '  
               A N D   t b _ i n t e g r a c a o _ m x m . s n _ a v u l s o   =   ' S '  
               A N D   f a n o t a v l . c o d _ u n i   =   ' 0 0 0 1 '    
  
 