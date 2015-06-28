//
//  UserPictureCache.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 28/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import Haneke
import Toucan

class UserPictureCache
{
    static let sharedInstance = UserPictureCache()
    
    let cache = Shared.imageCache
    let thumbnailFormat = Format<UIImage>(name: "thumbnail", diskCapacity: 10 * 1024 * 1024) { image in
        let resizedImage = Toucan.Resize.resizeImage(image, size: CGSize(width: 50, height: 50))
        return Toucan.Mask.maskImageWithRoundedRect(resizedImage, cornerRadius: 8, borderWidth: 1, borderColor: UIColor(rgba: Storyboard.PrimaryColor))
    }
    let normalPictureFormat = Format<UIImage>(name: "normal", diskCapacity: 10 * 1024 * 1024) { image in
        let resizedImage = Toucan.Resize.resizeImage(image, size: CGSize(width: 200, height: 200))
        return Toucan.Mask.maskImageWithRoundedRect(resizedImage, cornerRadius: 8, borderWidth: 1, borderColor: UIColor(rgba: Storyboard.PrimaryColor))
    }
    
    init()
    {
        cache.addFormat(thumbnailFormat)
        cache.addFormat(normalPictureFormat)
    }
    
    
    /**
        Fetch, cache and resize user thumbnails.
    
        :param: userId (not username)
    
        :returns: Fetch<UIImage> Promised UIImage for async processing, image will be 50x50
    */
    func thumbnailById(userId: Int) -> Fetch<UIImage>
    {
        return cache.fetch(URL: thumbnailURLFromId(userId), formatName: "thumbnail")
    }
    
    /**
        Fetch, cache and resize user (mobile, not full size) pictures.
        
        :param: userId (not username)
        
        :returns: Fetch<UIImage> Promised UIImage for async processing, image will be 200x200
    */
    func pictureById(userId: Int) -> UIImage
    {
        return UIImage()
    }
    
    /**
        Returns the URL for the thumbnail picture.
    
        :param: userId
    
        :returns: NSURL
    */
    private func thumbnailURLFromId(userId: Int) -> NSURL
    {
        let baseUrl = "https://www.warmshowers.org/files/imagecache/profile_picture/pictures/picture-%d.jpg"
        let url = NSURL(string: NSString(format: baseUrl, userId) as String)
        return url!;
    }
    
    /**
        Returns the URL for the normal picture.
        
        :param: userId
        
        :returns: NSURL
    */
    private func mobileURLFromId(userId: Int) -> NSURL
    {
        let baseUrl = "https://www.warmshowers.org/files/imagecache/mobile_photo_4x3/pictures/picture-%d.jpg"
        let url = NSURL(string: NSString(format: baseUrl, userId) as String)
        return url!;
    }
}
